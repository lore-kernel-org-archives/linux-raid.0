From: Philippe =?ISO-8859-15?Q?Gramoull=E9?=
	<philippe.gramoulle@mmania.com>
Subject: mdadm can't start RAID0 volume after power failure
Date: Fri, 17 Dec 2004 18:29:52 +0100
Message-ID: <20041217182952.4b5ecfb3.philippe.gramoulle@mmania.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hello,

i'm looking to understand why i can't start my RAID0 volume since i had a power failure this afternoon.
Nothing regarding hardware was changed/added/removed.

System    : Debian Unstable + Kernel 2.6.7-mm4 (worked rock solid for months)
Hardware  : Dell Poweredge 2600 + 2xPowervault 210S diskshelves + PERC3/QC RAID adapter
Filesystem: ReiserFS, /dev/md0 built last February, 500 Go
mdadm     : 1.7.0

The underlying Hardware RAID 1 part looks ok : each /dev/sd[efghijk]1 is a hardware RAID 1
which is set on the PERC RAID adapter. Every logical volume is reported as "optimal" state

Out of these 7 logical volumes, i've built a Software RAID-0 using mdadm:

# cat /etc/mdadm/mdadm.conf

DEVICE /dev/sd[efghijk]1
ARRAY /dev/md0 level=raid0 num-devices=7 UUID=46c66ef8:8acf2810:48adb2d3:85b04900
   devices=/dev/sdk1,/dev/sdj1,/dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1

After the power failure, i can't start the RAID0 device anymore:
 
# mdadm -v -A /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdk1 has wrong uuid.
mdadm: /dev/sdj1 has wrong uuid.
mdadm: /dev/sdi1 has wrong uuid.
mdadm: /dev/sdh1 has wrong uuid.
mdadm: /dev/sdg1 has wrong uuid.
mdadm: /dev/sdf1 has wrong uuid.
mdadm: /dev/sde1 has wrong uuid.
mdadm: no devices found for /dev/md0


Still, every # mdadm -E /dev/sd[efghijk]1 looks ok, output can be found here: http://philou.org/mdadm.log
mdadm.conf is here : http://philou.org/mdadm.conf

# mdadm -QE --scan
ARRAY /dev/md0 level=raid0 num-devices=7 UUID=3c1ad678:d3a7a1ed:1112143d:68b4e569
   devices=/dev/sdk1,/dev/sdj1,/dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1


Any hope to get my data back ?

Thanks,

Philippe
