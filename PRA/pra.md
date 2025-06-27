# 🛠️ Plan de Reprise d’Activité – Base de données Zabbix

## 🎯 Objectif

Ce Plan de Reprise d'Activité (PRA) a pour but de restaurer le bon fonctionnement de la supervision Zabbix en cas de **corruption critique de la base de données PostgreSQL**.

---

## ⚠️ Scénario de sinistre

- L'application Zabbix est inaccessible ou instable.
- Le service `zabbix-server` ne démarre plus ou plante.
- La base PostgreSQL `zabbix` est corrompue (logs avec `FATAL`, `PANIC`, ou erreurs de lecture).
- Une sauvegarde quotidienne existe sur un **serveur de sauvegarde distant**.

---

## 🗂️ Informations techniques

| Élément              | Valeur                       |
|----------------------|------------------------------|
| Serveur Zabbix       | `192.168.3.4`                |
| Serveur de sauvegarde| `192.168.6.6`                |
| Utilisateur BDD      | `zabbix`                     |
| Nom de la base       | `zabbix`                     |
| Port PostgreSQL      | `5432`                       |
| Chemin des sauvegardes | `/backup/zabbix/`          |
| Format du dump       | SQL texte (`.sql`)           |

---

## 🧰 Étapes de reprise

### 1. 🔒 **Mise en sécurité**

- Connectez-vous au serveur Zabbix.
- Stoppez le service Zabbix pour éviter toute écriture :

```bash
sudo systemctl stop zabbix-server

2. 📥 Récupération de la sauvegarde

Sur le serveur Zabbix, copiez la dernière sauvegarde disponible :

```bash 
scp root@192.168.6.6:/backup/zabbix/zabbix_dump_YYYYMMDD.sql /tmp/zabbix_restore.sql
```

Veuillez remplacer  YYYYMMDD par la date souhaitée (généralement la veille).

3. 🗑️ Suppression de la base corrompue 

Connectez-vous en tant que superutilisateur PostgreSQL :
```bash
sudo -u postgres psql
```

Lancer les commandes SQL suivant : 
```bash
DROP DATABASE IF EXISTS zabbix;
CREATE DATABASE zabbix OWNER zabbix ENCODING 'UTF8';
\q
```

4. 📦 Restauration du dump : 

```bash
psql -U zabbix -d zabbix -f /tmp/zabbix_restore.sql
```

5. ✅ Redémarrage de Zabbix

```bash
sudo systemctl start zabbix-server
```

6. 🔍 Vérifications post-reprise

- Interface web Zabbix accessible ?

- Hôtes présents ?

- Données historiques disponibles ?

- Fichier de logs : /var/log/zabbix/zabbix_server.log

💡 Bonnes pratiques
Tester cette procédure régulièrement (préprod / maquette)

Automatiser les sauvegardes avec un cron + rotation

Conserver plusieurs jours de sauvegardes

Vérifier l’intégrité des dumps via pg_restore --list ou test local

