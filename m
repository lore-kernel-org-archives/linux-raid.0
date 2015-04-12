From: Thomas MARCHESSEAU <marchesseau@gmail.com>
Subject: RAID 5 "magicaly" become a RAID0
Date: Sun, 12 Apr 2015 23:42:35 +0200
Message-ID: <D150B36B.8EE37%marchesseau@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi team ,

Like probably lot of  new subscriber , i mail you, guys,  for help .

I=B9m running a raid5 on 7 HDD for several month now ( and years on oth=
er
system) without problem .
last week i had a crash disk (sdg)  , i=B9ve add a new drive (sdi)  and
rebuild ..  Works fine , and i dont think this is the cause of my today
problem.

Yesterday , i=B9v upgraded my ubuntu 14.10 , and the system warm me wit=
h a
message that i can=B9t recall and rewrite exactly , but something like =
:
md127 doesn=B9t not match with /etc/mdadm/mdadm.conf ,  blah blah , run
/usr/share/mdadm/mkconf , and fix /etc/mdadm/mdadm.conf

i=B9ve done it , and reboot , all looks good .
All the drive have been rename after reboot ( orginal sdg was extract f=
orm
the bay ) =20

I=B9ve setup a rsync of my most important data on a external drive this
night, who partially failed  (only 25% ha been backuped , bad luck )  ,
(probably) because  this morning  i have re-inserted by mistake the fau=
lty
drive ( for information , i think the drive was in fact ok , the sata
connector was a bit disconnect )

I did not pay attention of the situation at the moment , but few hour
later , i ssh my filer and my =AB home =BB  (on the raid partition) was=
 not
available anymore .
I didn=B9t try to fschk or any thing else than :

Mdadm =8Bstop /dev/md127
mdadm --assemble /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sd=
f
/dev/sdg /dev/sdh=20
mdadm: /dev/md127 assembled from 5 drives - not enough to start the arr=
ay.


So i=B9ve read a bunch of usefull link , one of them :) ,
https://raid.wiki.kernel.org/index.php/RAID_Recovery  , says , don=B9t =
do
stupid thing until drop a mail on linux-raid mailling =8A so i=B9m here=
  .

i=B9ve collected  this usefull info :
mdadm --examine /dev/sd[a-z] | egrep 'Event|/dev/sd'
/dev/sda: (system HDD )
/dev/sdb:
         Events : 21958
/dev/sdc:
         Events : 21958
/dev/sdd:
         Events : 21958
/dev/sde:
         Events : 21958
/dev/sdf:
         Events : 21958
/dev/sdg:
         Events : 21954  <=8B here
/dev/sdh:
         Events : 21954  <=8B and here



i=B9ve also a full copy of mdadm =8Bexamine

The strange thing is that  my raid array is now seen as a RAID0 in
mdadm --detail /dev/md127
/dev/md127:
        Version :=20
     Raid Level : raid0
  Total Devices : 0

          State : inactive


But individually all drive in mdadm =8Bexamine , are RAID 5 member .

Anyone for help  ?

i=B9 was on the way to perform a
mdadm --create --assume-clean =8Blevel=3D5 --raid-devices=3D7 --size=3D=
11720300544
/dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/s=
dh

Which looks a bit stupid before ask for help

Regards thomas=20



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
