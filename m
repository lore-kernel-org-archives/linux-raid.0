From: Stephane Bunel <stephane.bunel@forumdesimages.fr>
Subject: Re: mdadm --detail showing annoying device
Date: Tue, 03 Nov 2009 10:37:47 +0100
Message-ID: <4AEFF9EB.2050502@forumdesimages.fr>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>	<20091019030456.GS9464@discord.disaster>	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>	<20091020003358.GW9464@discord.disaster>	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>	<4ADF17EC.6090606@forumdesimages.fr>	<19167.33065.766493.889406@notabene.brown>	<4AE0408C.3090500@forumdesimages.fr> <19177.3970.674526.401872@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19177.3970.674526.401872@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown a =E9crit :
(...)

> On your system, /dev/char/21:0 is a block device (or a link to a bloc=
k
> device) so there is clearly some sort of configuration error.

All files in /dev/char are symlinks (see below). Rules are comming from=
 Gentoo.

> If you still cannot find it, maybe you could show us the change you
> made to udev.rules, and an 'ls -l' of '/dev/char'.  That might help
> shed some light on your situation.

Considering mdadm is only involved by "real" block device file, why not=
 just=20
skipping symlink ?

  o Udev rules used to rename /dev/sd[ab]:

#cat 65-persistent-block.rules
ENV{PHYSDEVPATH}=3D=3D"/devices/pci0000:00/0000:00:1f.2/host0/target0:0=
:0/0:0:0:0",=20
NAME=3D"raid_disk0"

ENV{PHYSDEVPATH}=3D=3D"/devices/pci0000:00/0000:00:1f.2/host1/target1:0=
:0/1:0:0:0",=20
NAME=3D"raid_disk1"

  o System is Gentoo.
  o Content of /dev/char:

#ls -la /dev/char/
total 0
drwxr-xr-x  2 root root 2880 2009-11-02 16:26 .
drwxr-xr-x 16 root root 3480 2009-11-02 16:26 ..
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 10:1 -> ../psaux
lrwxrwxrwx  1 root root    9 2009-10-16 18:12 10:227 -> ../mcelog
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 10:229 -> ../fuse
lrwxrwxrwx  1 root root   11 2009-10-16 18:12 10:231 -> ../snapshot
lrwxrwxrwx  1 root root   13 2009-10-16 18:12 10:252 -> ../dac960_gam
lrwxrwxrwx  1 root root   11 2009-10-16 18:12 10:58 -> ../megadev0
lrwxrwxrwx  1 root root    6 2009-10-16 18:12 10:59 -> ../tgt
lrwxrwxrwx  1 root root   21 2009-10-16 18:12 10:60 -> ../network_throu=
ghput
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 10:61 -> ../network_laten=
cy
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 10:62 -> ../cpu_dma_laten=
cy
lrwxrwxrwx  1 root root   17 2009-10-16 18:12 10:63 -> ../mapper/contro=
l
lrwxrwxrwx  1 root root    6 2009-10-16 18:12 1:1 -> ../mem
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 1:11 -> ../kmsg
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 1:2 -> ../kmem
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 1:3 -> ../null
lrwxrwxrwx  1 root root   12 2009-10-16 18:12 13:0 -> ../input/js0
lrwxrwxrwx  1 root root   15 2009-10-16 18:12 13:32 -> ../input/mouse0
lrwxrwxrwx  1 root root   13 2009-10-16 18:12 13:63 -> ../input/mice
lrwxrwxrwx  1 root root   15 2009-10-16 18:12 13:64 -> ../input/event0
lrwxrwxrwx  1 root root   15 2009-10-16 18:12 13:65 -> ../input/event1
lrwxrwxrwx  1 root root   15 2009-10-16 18:12 13:67 -> ../input/event3
lrwxrwxrwx  1 root root   15 2009-10-16 18:12 13:68 -> ../input/event4
lrwxrwxrwx  1 root root   15 2009-10-16 18:12 13:69 -> ../input/event5
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 1:4 -> ../port
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 1:5 -> ../zero
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 1:7 -> ../full
lrwxrwxrwx  1 root root    9 2009-10-16 18:12 1:8 -> ../random
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 189:0 -> ../bus/usb/001/0=
01
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 189:128 -> ../bus/usb/002=
/001
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 189:129 -> ../bus/usb/002=
/002
lrwxrwxrwx  1 root root   18 2009-11-02 16:25 189:133 -> ../bus/usb/002=
/006
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 189:256 -> ../bus/usb/003=
/001
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 189:384 -> ../bus/usb/004=
/001
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 189:385 -> ../bus/usb/004=
/002
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 189:512 -> ../bus/usb/005=
/001
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 189:640 -> ../bus/usb/006=
/001
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 189:768 -> ../bus/usb/007=
/001
lrwxrwxrwx  1 root root   18 2009-10-16 18:12 189:896 -> ../bus/usb/008=
/001
lrwxrwxrwx  1 root root   10 2009-10-16 18:12 1:9 -> ../urandom
lrwxrwxrwx  1 root root   13 2009-10-16 18:12 21:0 -> ../raid_disk0
lrwxrwxrwx  1 root root   13 2009-10-16 18:12 21:1 -> ../raid_disk1
lrwxrwxrwx  1 root root    6 2009-11-02 16:26 21:2 -> ../sg2
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 248:0 -> ../rtc0
lrwxrwxrwx  1 root root   10 2009-10-16 18:12 254:0 -> ../hidraw0
lrwxrwxrwx  1 root root   10 2009-10-16 18:12 254:1 -> ../hidraw1
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 4:0 -> ../tty0
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 4:1 -> ../tty1
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:10 -> ../tty10
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:11 -> ../tty11
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:12 -> ../tty12
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:13 -> ../tty13
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:14 -> ../tty14
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:15 -> ../tty15
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:16 -> ../tty16
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:17 -> ../tty17
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:18 -> ../tty18
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:19 -> ../tty19
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 4:2 -> ../tty2
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:20 -> ../tty20
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:21 -> ../tty21
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:22 -> ../tty22
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:23 -> ../tty23
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:24 -> ../tty24
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:25 -> ../tty25
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:26 -> ../tty26
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:27 -> ../tty27
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:28 -> ../tty28
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:29 -> ../tty29
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 4:3 -> ../tty3
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:30 -> ../tty30
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:31 -> ../tty31
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:32 -> ../tty32
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:33 -> ../tty33
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:34 -> ../tty34
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:35 -> ../tty35
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:36 -> ../tty36
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:37 -> ../tty37
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:38 -> ../tty38
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:39 -> ../tty39
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 4:4 -> ../tty4
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:40 -> ../tty40
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:41 -> ../tty41
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:42 -> ../tty42
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:43 -> ../tty43
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:44 -> ../tty44
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:45 -> ../tty45
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:46 -> ../tty46
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:47 -> ../tty47
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:48 -> ../tty48
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:49 -> ../tty49
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 4:5 -> ../tty5
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:50 -> ../tty50
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:51 -> ../tty51
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:52 -> ../tty52
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:53 -> ../tty53
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:54 -> ../tty54
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:55 -> ../tty55
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:56 -> ../tty56
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:57 -> ../tty57
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:58 -> ../tty58
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:59 -> ../tty59
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 4:6 -> ../tty6
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:60 -> ../tty60
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:61 -> ../tty61
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:62 -> ../tty62
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:63 -> ../tty63
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:64 -> ../ttyS0
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:65 -> ../ttyS1
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:66 -> ../ttyS2
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 4:67 -> ../ttyS3
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 4:7 -> ../tty7
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 4:8 -> ../tty8
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 4:9 -> ../tty9
lrwxrwxrwx  1 root root    6 2009-10-16 18:12 5:0 -> ../tty
lrwxrwxrwx  1 root root   10 2009-10-16 18:12 5:1 -> ../console
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 5:2 -> ../ptmx
lrwxrwxrwx  1 root root    6 2009-10-16 18:12 7:0 -> ../vcs
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 7:1 -> ../vcs1
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:10 -> ../vcs10
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:11 -> ../vcs11
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:12 -> ../vcs12
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 7:128 -> ../vcsa
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:129 -> ../vcsa1
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:130 -> ../vcsa2
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:131 -> ../vcsa3
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:132 -> ../vcsa4
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:133 -> ../vcsa5
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:134 -> ../vcsa6
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:135 -> ../vcsa7
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:136 -> ../vcsa8
lrwxrwxrwx  1 root root    8 2009-10-16 18:12 7:137 -> ../vcsa9
lrwxrwxrwx  1 root root    9 2009-10-16 18:12 7:138 -> ../vcsa10
lrwxrwxrwx  1 root root    9 2009-10-16 18:12 7:139 -> ../vcsa11
lrwxrwxrwx  1 root root    9 2009-10-16 18:12 7:140 -> ../vcsa12
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 7:2 -> ../vcs2
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 7:3 -> ../vcs3
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 7:4 -> ../vcs4
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 7:5 -> ../vcs5
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 7:6 -> ../vcs6
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 7:7 -> ../vcs7
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 7:8 -> ../vcs8
lrwxrwxrwx  1 root root    7 2009-10-16 18:12 7:9 -> ../vcs9

St=E9phane Bunel.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
