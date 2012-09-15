From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Sun, 16 Sep 2012 00:06:48 +0200
Message-ID: <5054FBF8.8070901@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se> <5052E096.5040509@linuxsystems.it> <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com> <20120914182755.GA2534@cthulhu.home.robinhill.me.uk> <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com> <5054D175.5070303@linuxsystems.it> <20120915194102.GA10403@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120915194102.GA10403@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il 15/09/2012 21:41, Robin Hill ha scritto:
> If md hasn't failed the drive then either:
>    - md didn't get a read error
>    - md got a success message when re-writing the block
>    - there's a bug in md and it's not handled the error at all

It seems it's case one, while manually verifying the checksums with

for i in $(seq 50); do dd if=3D/dev/sda1 of=3Dsda${i} bs=3D100000 count=
=3D50=20
skip=3D$((($i-1)*50+10)) > /dev/null 2> /dev/null; dd if=3D/dev/sdb1=20
of=3Dsdb${i} bs=3D100000 count=3D50 skip=3D$((($i-1)*50+10)) > /dev/nul=
l 2>=20
/dev/null; md5sum sda${i}; md5sum sdb${i}; echo; done

I get this in syslog:

Sep 15 23:50:09 asterisk kernel: [273828.407914] scsi_verify_blk_ioctl:=
=20
30 callbacks suppressed
Sep 15 23:50:09 asterisk kernel: [273828.407920] dd: sending ioctl=20
80306d02 to a partition!
Sep 15 23:50:09 asterisk kernel: [273828.407925] dd: sending ioctl=20
80306d02 to a partition!
Sep 15 23:50:10 asterisk kernel: [273829.422247] ata3.00: exception=20
Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Sep 15 23:50:10 asterisk kernel: [273829.424071] ata3.00: BMDMA stat 0x=
44
Sep 15 23:50:10 asterisk kernel: [273829.425855] ata3.00: failed=20
command: READ DMA
Sep 15 23:50:10 asterisk kernel: [273829.427625] ata3.00: cmd=20
c8/00:00:68:17:00/00:00:00:00:00/e0 tag 0 dma 131072 in
Sep 15 23:50:10 asterisk kernel: [273829.427627]          res=20
51/40:00:90:17:00/40:00:00:00:00/e0 Emask 0x9 (media error)
Sep 15 23:50:10 asterisk kernel: [273829.431184] ata3.00: status: { DRD=
Y=20
ERR }
Sep 15 23:50:10 asterisk kernel: [273829.432992] ata3.00: error: { UNC =
}
Sep 15 23:50:11 asterisk kernel: [273830.404203] ata3.00: configured fo=
r=20
UDMA/133
Sep 15 23:50:11 asterisk kernel: [273830.404217] ata3: EH complete



but this is the output of the command:


b7d4e3c3bb461a1aa6619c22ef11d072  sda1
b7d4e3c3bb461a1aa6619c22ef11d072  sdb1

8649ae5a732bc808f228677b27a1e9b6  sda2
8649ae5a732bc808f228677b27a1e9b6  sdb2

8649ae5a732bc808f228677b27a1e9b6  sda3
8649ae5a732bc808f228677b27a1e9b6  sdb3

8649ae5a732bc808f228677b27a1e9b6  sda4
8649ae5a732bc808f228677b27a1e9b6  sdb4

8649ae5a732bc808f228677b27a1e9b6  sda5
8649ae5a732bc808f228677b27a1e9b6  sdb5

8649ae5a732bc808f228677b27a1e9b6  sda6
8649ae5a732bc808f228677b27a1e9b6  sdb6

8649ae5a732bc808f228677b27a1e9b6  sda7
8649ae5a732bc808f228677b27a1e9b6  sdb7

f2fb77841db5dd577449cfeee07c4108  sda8
f2fb77841db5dd577449cfeee07c4108  sdb8

e311789a1fabd3758694c35c74e20612  sda9
e311789a1fabd3758694c35c74e20612  sdb9

8649ae5a732bc808f228677b27a1e9b6  sda10
8649ae5a732bc808f228677b27a1e9b6  sdb10

8649ae5a732bc808f228677b27a1e9b6  sda11
8649ae5a732bc808f228677b27a1e9b6  sdb11

8649ae5a732bc808f228677b27a1e9b6  sda12
8649ae5a732bc808f228677b27a1e9b6  sdb12

8649ae5a732bc808f228677b27a1e9b6  sda13
8649ae5a732bc808f228677b27a1e9b6  sdb13

8649ae5a732bc808f228677b27a1e9b6  sda14
8649ae5a732bc808f228677b27a1e9b6  sdb14

8649ae5a732bc808f228677b27a1e9b6  sda15
8649ae5a732bc808f228677b27a1e9b6  sdb15

8649ae5a732bc808f228677b27a1e9b6  sda16
8649ae5a732bc808f228677b27a1e9b6  sdb16

8649ae5a732bc808f228677b27a1e9b6  sda17
8649ae5a732bc808f228677b27a1e9b6  sdb17

8649ae5a732bc808f228677b27a1e9b6  sda18
8649ae5a732bc808f228677b27a1e9b6  sdb18

8649ae5a732bc808f228677b27a1e9b6  sda19
8649ae5a732bc808f228677b27a1e9b6  sdb19

8649ae5a732bc808f228677b27a1e9b6  sda20
8649ae5a732bc808f228677b27a1e9b6  sdb20

8649ae5a732bc808f228677b27a1e9b6  sda21
8649ae5a732bc808f228677b27a1e9b6  sdb21

8649ae5a732bc808f228677b27a1e9b6  sda22
8649ae5a732bc808f228677b27a1e9b6  sdb22

8649ae5a732bc808f228677b27a1e9b6  sda23
8649ae5a732bc808f228677b27a1e9b6  sdb23

8649ae5a732bc808f228677b27a1e9b6  sda24
8649ae5a732bc808f228677b27a1e9b6  sdb24

8649ae5a732bc808f228677b27a1e9b6  sda25
8649ae5a732bc808f228677b27a1e9b6  sdb25

8649ae5a732bc808f228677b27a1e9b6  sda26
8649ae5a732bc808f228677b27a1e9b6  sdb26

4531da1579310425e2d3343846f5b16d  sda27
4531da1579310425e2d3343846f5b16d  sdb27

3721bf34547dc2967741bf6bfbd76670  sda28
3721bf34547dc2967741bf6bfbd76670  sdb28

14a2be518f90d3060b3438ac75d91e7e  sda29
14a2be518f90d3060b3438ac75d91e7e  sdb29

36fb275af7608d0aff8c7b454168f8c3  sda30
36fb275af7608d0aff8c7b454168f8c3  sdb30

2026b2cf40470f059d264b2c78f3a989  sda31
2026b2cf40470f059d264b2c78f3a989  sdb31

36f825d926a6195c70efabd0a045fce0  sda32
36f825d926a6195c70efabd0a045fce0  sdb32

44be6fdd8adb83f1328d6fa21e72a5f9  sda33
44be6fdd8adb83f1328d6fa21e72a5f9  sdb33

90a771705992c1ba15c17a30520b0b56  sda34
90a771705992c1ba15c17a30520b0b56  sdb34

c37584adcad03dc74b0ea9e431fd78e3  sda35
c37584adcad03dc74b0ea9e431fd78e3  sdb35

f044f24e528316cf5a40e894e7d84c36  sda36
f044f24e528316cf5a40e894e7d84c36  sdb36

4447d6a338fdac8cf179dde83deb7f43  sda37
4447d6a338fdac8cf179dde83deb7f43  sdb37

b4115994e66cb739dc49fedcaf5649eb  sda38
b4115994e66cb739dc49fedcaf5649eb  sdb38

65c9226105cbba0fd7dbefb9bedac940  sda39
65c9226105cbba0fd7dbefb9bedac940  sdb39

e05366f8be4b66595c2aadbb133c6b4c  sda40
e05366f8be4b66595c2aadbb133c6b4c  sdb40

afc039520def52590a5fd289b423545a  sda41
afc039520def52590a5fd289b423545a  sdb41

6d47c3b1265afc3dbbd832d8088501c4  sda42
6d47c3b1265afc3dbbd832d8088501c4  sdb42

749140fe9a80f20dd5449976db66ce0f  sda43
749140fe9a80f20dd5449976db66ce0f  sdb43

41bd354c1cca819dd4a8d19b8c1a637e  sda44
41bd354c1cca819dd4a8d19b8c1a637e  sdb44

b2fc15b0147853d76a7c5fe87820d26b  sda45
b2fc15b0147853d76a7c5fe87820d26b  sdb45

a9b3ac7ac3556950887959dea3b6ae3c  sda46
a9b3ac7ac3556950887959dea3b6ae3c  sdb46

3daf2ee98c1d3d24f779234f6f7d58d6  sda47
3daf2ee98c1d3d24f779234f6f7d58d6  sdb47

31fe58f24393d199b63102a45b8b44c3  sda48
31fe58f24393d199b63102a45b8b44c3  sdb48

43e0657b350cd60efdf1ca0c8324f85c  sda49
43e0657b350cd60efdf1ca0c8324f85c  sdb49

94f883b45084b72cd9269a4821b2d509  sda50
94f883b45084b72cd9269a4821b2d509  sdb50



*BUT* if I start reading from the start of partition (+0 instead of +10=
=20
in count=3D) I get a mismatch, on both md0 and md1 (which is supposed t=
o=20
be ok)!!!

root@asterisk:~# i=3D1; dd if=3D/dev/sda1 of=3Dsda${i} bs=3D100000 coun=
t=3D50=20
skip=3D$((($i-1)*50+0)) > /dev/null 2> /dev/null; dd if=3D/dev/sdb1=20
of=3Dsdb${i} bs=3D100000 count=3D50 skip=3D$((($i-1)*50+0)) > /dev/null=
 2>=20
/dev/null; md5sum sda${i}; md5sum sdb${i}
9f9f11ffeb0aed0abc8097417b293f41  sda1
394efde218ad700774bfcb3c43255529  sdb1
root@asterisk:~# i=3D1; dd if=3D/dev/sda2 of=3Dsda${i} bs=3D100000 coun=
t=3D50=20
skip=3D$((($i-1)*50+0)) > /dev/null 2> /dev/null; dd if=3D/dev/sdb2=20
of=3Dsdb${i} bs=3D100000 count=3D50 skip=3D$((($i-1)*50+0)) > /dev/null=
 2>=20
/dev/null; md5sum sda${i}; md5sum sdb${i}
8cb0b6fa2bf7f0f88a2a2a91598429d4  sda1
732c42e14b8e78930d08cdb4f1c49a40  sdb1

Shouldn't raid1 match even at the very beginning of the partition?


Il 15/09/2012 22:40, Roberto Spadim ha scritto:
 > today disks arent expensives, why not change the disk and be happy?

Because I get the problem after a power failure, disk *should* be ok I=20
think.

Cheers,
Niccol=F2
--=20
http://www.linuxsystems.it
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
