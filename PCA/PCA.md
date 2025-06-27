# PCA – Continuité d’Accès Réseau via Cluster pfSense (CARP)

## 1. Objectif

Assurer la **continuité du service réseau** (LAN/WAN/VPN) grâce à un **cluster de pare-feux pfSense** configurés en haute disponibilité avec **CARP (Common Address Redundancy Protocol)**.  
Le système garantit la résilience en cas de panne d’un des deux équipements pfSense.

---

## 2.  Périmètre

| Élément               | Détail                                    |
|------------------------|-------------------------------------------|
| Technologie            | pfSense en haute disponibilité (HA)      |
| Protocole              | CARP (failover actif/passif)             |
| Redondance             | 2 nœuds (MASTER / BACKUP)                |
| Synchronisation        | XML-RPC / synchronisation d’état         |
| Localisation           | Salle serveur principale                 |

---

## 3.  Architecture Réseau & VIPs

### Interfaces et IPs Virtuelles configurées (CARP)

| Interface     | VHID | Adresse IP Virtuelle | Description           | Statut   |
|---------------|------|----------------------|------------------------|----------|
| WAN           | @1   | `10.4.0.179/16`       | VIP WAN                | MASTER   |
| LAN SOC       | @2   | `192.168.1.100/24`    | VIP LAN SOC            | MASTER   |
| LAN WINDOWS   | @3   | `192.168.2.100/24`    | VIP LAN WINDOWS        | MASTER   |
| MONITORING    | @4   | `192.168.3.100/24`    | VIP LAN MONITORING     | MASTER   |
| SERVEURS      | @5   | `192.168.4.100/32`    | VIP LAN SERVEURS       | MASTER   |
| CLIENTS       | @6   | `192.168.5.100/32`    | VIP LAN CLIENTS        | MASTER   |
| SAVE          | @7   | `192.168.6.100/32`    | VIP LAN SAVE           | MASTER   |

Toutes les interfaces CARP sont actuellement en **état MASTER**, indiquant que ce nœud est actif.

---

## 4. ⚠️ Risques Couvert par le PCA

| Risque identifié                  | Conséquence sans PCA     | Mitigation grâce au PCA pfSense |
|-----------------------------------|--------------------------|----------------------------------|
| Panne matérielle sur un pfSense   | Rupture réseau           | Basculement automatique via CARP |
| Mise à jour d’un pare-feu         | Interruption réseau      | Maintien du service via le backup |
| Crash logiciel                    | Perte d’accès Internet   | Prise en charge immédiate par le secondaire |
| Mauvaise configuration manuelle   | Déconnexion des clients  | Synchronisation contrôlée (XML-RPC) |

---

## 5. Procédure de Bascule

### ➤ Bascule Automatique
- Déclenchée en cas de perte de communication CARP, interface réseau inactive ou service critique KO.
- Le nœud secondaire devient automatiquement MASTER sur les VHIDs concernés.

### ➤ Bascule Manuelle (entretien / maintenance)
1. Accéder à l'interface Web pfSense primaire.
2. Aller dans **Status > CARP**.
3. Cliquer sur **Temporarily Disable CARP** pour forcer la bascule.
4. L’autre pare-feu devient automatiquement MASTER.

➡️Pour réactiver :
- Cliquer sur **Enable CARP** une fois la maintenance terminée.

---

## 6.  Vérifications et Tests

| Test à effectuer           | Fréquence       | Résultat attendu                          |
|----------------------------|------------------|-------------------------------------------|
| Débranchement pfSense#1    | Trimestriel      | pfSense#2 devient MASTER sans coupure     |
| Test de bascule CARP       | Semestriel       | Le cluster répond à la VIP                |
| Test de synchronisation    | Après chaque MEP | Les règles sont identiques                |
| Test VPN & filtrage        | Annuel           | Fonctionnement normal sur backup          |

---

## 7.  Maintenance

- Toujours **désactiver CARP** temporairement avant de faire une mise à jour logicielle sur le nœud principal.
- Vérifier l’état de **synchronisation** dans l’interface web après toute modification :
  - `Status > CARP`
  - `Status > System Logs > Gateways`

---

## 8.  Bonnes pratiques

| Recommandation                        | Justification                           |
|--------------------------------------|-----------------------------------------|
| NTP actif sur les deux nœuds         | Synchronisation CARP stable             |
| VLANs correctement définis           | Éviter conflits de broadcast CARP       |
| Interfaces nommées de façon claire   | Meilleure traçabilité des VIPs          |
| Scripts de monitoring personnalisés  | Détection rapide des bascules           |

---

## 9.  Fiche de Contact d'Urgence

| Rôle                     | Nom / Contact              |
|--------------------------|----------------------------|
| Administrateur réseau    | Jean Dupuis / Poste 215    |
| Responsable Informatique | Marie Leclerc / Poste 101  |
| FAI - Lien WAN           | Orange – 0 800 XXX XXX     |

---

## 10.  Historique des Tests

| Date       | Type de test         | Résultat | Remarques                   |
|------------|----------------------|----------|-----------------------------|
| 2025-04-10 | Test de bascule WAN  | ✅       | Basculement instantané      |
| 2025-05-15 | Maintenance pare-feu | ✅       | Synchronisation vérifiée    |
| 2025-06-25 | Simulation panne     | ✅       | VIP LAN SOC opérationnelle  |

---

##  Conclusion

Le cluster pfSense en place couvre efficacement les risques de **panne ou de maintenance** réseau.  
Les VIPs assurent la **transparence du basculement** pour les utilisateurs et les serveurs, garantissant une **qualité de service constante**, même en cas de défaillance d’un des nœuds.


