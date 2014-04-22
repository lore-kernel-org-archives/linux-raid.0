From: Roland RoLaNd <r_o_l_a_n_d@hotmail.com>
Subject: raid 10 only  spares showing
Date: Tue, 22 Apr 2014 20:44:24 +0200
Message-ID: <DUB121-W159AF5D9DC69F95CAC0D088A590@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i came across this mailing lsit while checking this wiki page ; https:/=
/raid.wiki.kernel.org/index.php/RAID_Recover

i had a server with 3 raid arrays:
1. system; 2 disks, raid 1 (_U)
2. data; 4 disks, raid 10 (UUUU)
3. misc; 4 disks, raid 10 (UUU_)

all of a sudden, DATA array had 1 failed drive (_UUU)
and system: (_U)

whenever i tried to examine with details, the whole system became unres=
ponsive, sysstat showed READ on one of the disks at MAX speed
as the system was unresponsive i had to reboot, which is when it went i=
nto "busy box/initramfs"
i asked the remote DC to install a new disk and isntall ubuntu over it,=
 they did and at boot it still went into "busy box" even though first b=
oot disk was the newly installed system.
they had to unplug all other disks, boot the system and then plug them =
back in.
naturally, the naming of these =A0disks changed due to this procces...=A0
now after a lot of troubleshooting, power recycling,etc...
i managed to salvage the "data" array and plugged it into another serve=
r.

i'm trying now to fix my "misc" array, executing mdadm --assemble --sca=
n doesnt work.

here's al the information i could think of gathering, if you require an=
y other info to better help me troubleshoot i'm all ears;

BLKIDs:
/dev/loop0: TYPE=3D"squashfs"=A0
/dev/sr0: LABEL=3D"Ubuntu 14.04 LTS amd64" TYPE=3D"iso9660"=A0
/dev/sdi2: UUID=3D"345c489c-63e3-4d58-c1c1-a2ac8ff8a6b6" UUID_SUB=3D"0a=
694075-0174-a774-d294-4f8d20632dea" LABEL=3D"ams:0" TYPE=3D"linux_raid_=
member"=A0
/dev/sdi3: UUID=3D"cbbd6bfa-0b94-1536-cfa5-9cdb802f0733" UUID_SUB=3D"46=
77f928-7c2a-e260-cbbd-f6a92ce20b66" LABEL=3D"ams:1" TYPE=3D"linux_raid_=
member"=A0
/dev/sdj2: UUID=3D"345c489c-63e3-4d58-c1c1-a2ac8ff8a6b6" UUID_SUB=3D"63=
22d0bd-e465-6940-12ba-39760cf7707f" LABEL=3D"ams:0" TYPE=3D"linux_raid_=
member"=A0
/dev/sdj3: UUID=3D"cbbd6bfa-0b94-1536-cfa5-9cdb802f0733" UUID_SUB=3D"3d=
03d2f8-fe6c-1d6b-0817-3915d46a7b1c" LABEL=3D"ams:1" TYPE=3D"linux_raid_=
member"=A0
/dev/sdl2: UUID=3D"ddd47847-9399-4265-8c63-f9cd74d201d3" TYPE=3D"ext4"=A0
/dev/sdl3: UUID=3D"6b6bf336-9e71-458a-9b16-6009b8e744d8" TYPE=3D"swap"=A0
/dev/sdl4: UUID=3D"2a171660-f5cf-40ab-8044-da3cb57bf1e9" TYPE=3D"ext4"=A0
/dev/sdg1: LABEL=3D"angh_HD02" UUID=3D"189A640A9A63E32C" TYPE=3D"ntfs"=A0
/dev/sdh1: LABEL=3D"angh_HD03" UUID=3D"B09CB4979CB45A14" TYPE=3D"ntfs"=A0
/dev/sdf1: LABEL=3D"angh_HD01" UUID=3D"1E06443406440F69" TYPE=3D"ntfs"=A0
/dev/sdc: UUID=3D"6d9f8ebe-164e-c09f-c845-e08f8499e99c" UUID_SUB=3D"58f=
5b920-76df-27f1-d68a-ae27f22425d2" LABEL=3D"ams:2" TYPE=3D"linux_raid_m=
ember"=A0
/dev/sdi4: UUID=3D"6d9f8ebe-164e-c09f-c845-e08f8499e99c" UUID_SUB=3D"08=
1aca1e-684d-aa5a-29e9-5cc7a15fc189" LABEL=3D"ams:2" TYPE=3D"linux_raid_=
member"=A0
/dev/sdj4: UUID=3D"6d9f8ebe-164e-c09f-c845-e08f8499e99c" UUID_SUB=3D"10=
9e6499-26e7-a967-dfe6-e721e6de1bc3" LABEL=3D"ams:2" TYPE=3D"linux_raid_=
member"=A0
/dev/sdk: UUID=3D"6d9f8ebe-164e-c09f-c845-e08f8499e99c" UUID_SUB=3D"bcf=
54b67-34b9-59f9-3e9a-6e7596fd6143" LABEL=3D"ams:2" TYPE=3D"linux_raid_m=
ember"=A0
/dev/md0: UUID=3D"79a513a8-d101-4097-a72a-fc82ec00ef6e" TYPE=3D"ext4"=A0



#output og mdadm --assemble --scanroot@ubuntu:/home/ubuntu# mdadm --ass=
emble --scan
mdadm: Devices UUID-6d9f8ebe:164ec09f:c845e08f:8499e99c and UUID-6d9f8e=
be:164ec09f:c845e08f:8499e99c have the same name: /dev/md/2
mdadm: Duplicate MD device names in conf file were found.

---#after commenting the first mdam.conf record for md2
root@ubuntu:~# mdadm --assemble --scan
mdadm: superblock on /dev/sdc doesn't match others - assembly aborted
mdadm: /dev/md/0 has been started with 1 drive (out of 2).
mdadm: /dev/md/1 assembled from 0 drives and 2 spares - not enough to s=
tart the array.
mdadm: superblock on /dev/sdc doesn't match others - assembly aborted
mdadm: /dev/md/1 is already in use.

#mdadm.conf (livecd)
# definitions of existing MD arrays
ARRAY /dev/md/2 metadata=3D1.2 UUID=3D6d9f8ebe:164ec09f:c845e08f:8499e9=
9c name=3Dams:2
=A0 =A0spares=3D1
ARRAY /dev/md/0 metadata=3D1.2 UUID=3D345c489c:63e34d58:c1c1a2ac:8ff8a6=
b6 name=3Dams:0
ARRAY /dev/md/1 metadata=3D1.2 UUID=3Dcbbd6bfa:0b941536:cfa59cdb:802f07=
33 name=3Dams:1
=A0 =A0spares=3D2
ARRAY /dev/md/2 metadata=3D1.2 UUID=3D6d9f8ebe:164ec09f:c845e08f:8499e9=
9c name=3Dams:2
=A0 =A0spares=3D3


#/proc/mdstat (live cd)
Personalities : [raid1]=A0
md1 : inactive sdj3[1](S) sdi3[0](S)
=A0 =A0 =A0 292966703 blocks super 1.2
=A0 =A0 =A0 =A0
md0 : active raid1 sdj2[1]
=A0 =A0 =A0 292957 blocks super 1.2 [2/1] [_U]
=A0 =A0 =A0=A0
unused devices: <none>

#output of mdadm -esvvv: (live cd)
http://pastebin.com/gua8sucb=A0
#had to use pastebin as output is a bit big


#output of bootinfoscript which is a handy tool i found online:
http://pastebin.com/7qdZURmv
#Had to use pastebin as output is a big big



 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
