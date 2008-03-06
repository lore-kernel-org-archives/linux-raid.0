From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: 16 HDDs too much for RAID6?
Date: Thu, 6 Mar 2008 11:55:59 +0100
Message-ID: <20080306115559.63ac361d.taeuber@bbaw.de>
References: <20080306100128.8daad6bd.taeuber@bbaw.de>
	<20080306094559.GA29734@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080306094559.GA29734@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andre,

> Run
> 	mdadm --zero-superblock /dev/dm-0
> 
> before creating the array to get rid of these.

ok, thanks.

> 
> > monosan:~ # mdadm --detail --scan| fgrep md4 >> /etc/mdadm.conf 
> 
> Please post your /etc/mdadm.conf

monosan:~ # cat /etc/mdadm.conf 
DEVICE partitions
ARRAY /dev/md2 level=raid1 UUID=d9d31de2:e6dbd3c3:37c7ea09:882a64e5
ARRAY /dev/md3 level=raid1 UUID=a8687183:a79e514c:ca492c4b:ffd4384f
ARRAY /dev/md4 level=raid6 num-devices=16 UUID=8d596319:4d21dba3:3871bccf:5b90a66d



> > monosan:~ # mdadm -A /dev/md4
> > mdadm: WARNING /dev/dm-9 and /dev/dm-8 appear to have very similar superblocks.
> >       If they are really different, please --zero the superblock on one
> >       If they are the same or overlap, please remove one from the
> >       DEVICE list in mdadm.conf.
> 
> Are you sure dm-8 and dm-9 are different devices?
> 
> 	pvdisplay /dev/dm-9; pvdisplay /dev/dm-8
> 
> should tell you.

Yes, I'm sure:
monosan:~ # pvdisplay /dev/dm-9; pvdisplay /dev/dm-8
  Failed to read physical volume "/dev/dm-9"
  Failed to read physical volume "/dev/dm-8"

but:
monosan:~ # multipathd -k
multipathd> list topology 
mpath0 (SATA_ST31000340NS_5QJ02QRQ) dm-0 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:32:0 sdah 66:16  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:15:0 sdr  65:16  [active][ready]
mpath1 (SATA_ST31000340NS_5QJ0204G) dm-1 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:31:0 sdag 66:0   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:14:0 sdq  65:0   [active][ready]
mpath2 (SATA_ST31000340NS_5QJ02TVQ) dm-2 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:30:0 sdaf 65:240 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:13:0 sdp  8:240  [active][ready]
mpath3 (SATA_ST31000340NS_5QJ012AL) dm-3 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:29:0 sdae 65:224 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:12:0 sdo  8:224  [active][ready]
mpath4 (SATA_ST31000340NS_5QJ00PHN) dm-4 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:28:0 sdad 65:208 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:11:0 sdn  8:208  [active][ready]
mpath5 (SATA_ST31000340NS_5QJ01BYF) dm-5 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:27:0 sdac 65:192 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:10:0 sdm  8:192  [active][ready]
mpath6 (SATA_ST31000340NS_5QJ026J1) dm-6 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:26:0 sdab 65:176 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:9:0  sdl  8:176  [active][ready]
mpath7 (SATA_ST31000340NS_5QJ01G09) dm-7 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:25:0 sdaa 65:160 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:8:0  sdk  8:160  [active][ready]
rename: mpath9 (SATA_ST31000340NS_5QJ02461) dm-8 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:24:0 sdz  65:144 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:7:0  sdj  8:144  [active][ready]
reload: mpath10 (SATA_ST31000340NS_5QJ013GW) dm-9 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:23:0 sdy  65:128 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:6:0  sdi  8:128  [active][ready]
mpath11 (SATA_ST31000340NS_5QJ01835) dm-10 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:22:0 sdx  65:112 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:5:0  sdh  8:112  [active][ready]
mpath12 (SATA_ST31000340NS_5QJ01C49) dm-11 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:21:0 sdw  65:96  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:4:0  sdg  8:96   [active][ready]
mpath13 (SATA_ST31000340NS_5QJ02TBZ) dm-12 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:20:0 sdv  65:80  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:3:0  sdf  8:80   [active][ready]
mpath14 (SATA_ST31000340NS_5QJ01JSF) dm-13 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:19:0 sdu  65:64  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:2:0  sde  8:64   [active][ready]
mpath15 (SATA_ST31000340NS_5QJ02TBK) dm-14 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:18:0 sdt  65:48  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:1:0  sdd  8:48   [active][ready]
mpath16 (SATA_ST31000340NS_5QJ0185Y) dm-15 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:17:0 sds  65:32  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:0:0  sdc  8:32   [active][ready]
multipathd>

monosan:~ #  for DEV in /dev/sd[c-z] /dev/sda[a-h] ; do echo Serial $DEV ; smartctl -id sat $DEV ; done | fgrep Serial
Serial /dev/sdc
Serial Number:    5QJ0185Y
Serial /dev/sdd
Serial Number:    5QJ02TBK
Serial /dev/sde
Serial Number:    5QJ01JSF
Serial /dev/sdf
Serial Number:    5QJ02TBZ
Serial /dev/sdg
Serial Number:    5QJ01C49
Serial /dev/sdh
Serial Number:    5QJ01835
Serial /dev/sdi
Serial Number:    5QJ013GW
Serial /dev/sdj
Serial Number:    5QJ02461
Serial /dev/sdk
Serial Number:    5QJ01G09
Serial /dev/sdl
Serial Number:    5QJ026J1
Serial /dev/sdm
Serial Number:    5QJ01BYF
Serial /dev/sdn
Serial Number:    5QJ00PHN
Serial /dev/sdo
Serial Number:    5QJ012AL
Serial /dev/sdp
Serial Number:    5QJ02TVQ
Serial /dev/sdq
Serial Number:    5QJ0204G
Serial /dev/sdr
Serial Number:    5QJ02QRQ
Serial /dev/sds
Serial Number:    5QJ0185Y
Serial /dev/sdt
Serial Number:    5QJ02TBK
Serial /dev/sdu
Serial Number:    5QJ01JSF
Serial /dev/sdv
Serial Number:    5QJ02TBZ
Serial /dev/sdw
Serial Number:    5QJ01C49
Serial /dev/sdx
Serial Number:    5QJ01835
Serial /dev/sdy
Serial Number:    5QJ013GW
Serial /dev/sdz
Serial Number:    5QJ02461
Serial /dev/sdaa
Serial Number:    5QJ01G09
Serial /dev/sdab
Serial Number:    5QJ026J1
Serial /dev/sdac
Serial Number:    5QJ01BYF
Serial /dev/sdad
Serial Number:    5QJ00PHN
Serial /dev/sdae
Serial Number:    5QJ012AL
Serial /dev/sdaf
Serial Number:    5QJ02TVQ
Serial /dev/sdag
Serial Number:    5QJ0204G
Serial /dev/sdah
Serial Number:    5QJ02QRQ

> 
> > This happens _always_ when the arreay is reassembled. The actual
> > devices with the duplicated superblocks differ sometimes.
> 
> If I read the code correctly it means that the two devices have
> identical superblocks, the same event count and the same minor number,
> so mdadm thinks dm-8 and dm-9 are overlapping partitions.

The multipathed drives are used as a whole without. The dont contain any partitions.

sdz and sdj are the same physical device with serial 5QJ02461 called /dev/dm-8:
rename: mpath9 (SATA_ST31000340NS_5QJ02461) dm-8 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:24:0 sdz  65:144 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:7:0  sdj  8:144  [active][ready]

similar to sdy and sdi with serial 5QJ013GW called /dev/dm-9
reload: mpath10 (SATA_ST31000340NS_5QJ013GW) dm-9 ATA     ,ST31000340NS  
[size=932G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 6:0:23:0 sdy  65:128 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 6:0:6:0  sdi  8:128  [active][ready]


 
> > Are 16 drivesmda too much for RAID6?
> 
> No, raid6 supports up to 254 devices (there are other reasons for
> not using too many devices for raid6 though).

Is there a way to get more verbose infos or debug this anyhow?

Thanks
Lars
