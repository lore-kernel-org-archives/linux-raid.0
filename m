From: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Re[2]: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Tue, 17 Jun 2014 16:12:55 +0200
Message-ID: <1769771799.20140617161255@oudeis.org>
References: <1896515726.20140614235853@oudeis.org>
 <1454723160.20140615203503@oudeis.org> <539E5A90.3080207@turmel.org>
 <19411862.20140616155327@oudeis.org> <539F00AE.9090504@turmel.org>
 <1153494452.20140616202024@oudeis.org> <539F5049.2080407@turmel.org>
 <145561825.20140616222858@oudeis.org> <539F5970.3060504@turmel.org>
 <1353040832.20140617032748@oudeis.org> <53A02D0C.90409@turmel.org>
Reply-To: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53A02D0C.90409@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi,

PT> It means that LVM is indeed using the scrambled array for those dev=
ices.
PT>  Use "dmsetup ls" to identify them.

[root@gateway ~]# dmsetup ls
vg_gateway-lv_data      (253, 2)
vg_gateway-lv_var       (253, 1)
vg_gateway-lv_home      (253, 0)
[root@gateway ~]#

those LVs are in use and on /dev/sda3 which LVM claims to use instead
of /dev/md1

PT> That also means my previous advice is wrong--you can't just shut it=
 off.
PT>  It would be helpful if you could run "lsdrv" [1] on your system an=
d
PT> report the results here.

[root@gateway lsdrv-master]# ./lsdrv
Creating device for node 11:0 ...
Creating device for node 253:2 ...
Creating device for node 253:1 ...
Creating device for node 253:0 ...
Creating device for node 9:1 ...
Creating device for node 9:0 ...
Creating device for node 8:16 ...
Creating device for node 8:19 ...
Creating device for node 8:18 ...
Creating device for node 8:17 ...
Creating device for node 8:0 ...
Creating device for node 8:3 ...
Creating device for node 8:2 ...
Creating device for node 8:1 ...
Creating device for node 1:15 ...
Creating device for node 1:14 ...
Creating device for node 1:13 ...
Creating device for node 1:12 ...
Creating device for node 1:11 ...
Creating device for node 1:10 ...
Creating device for node 1:9 ...
Creating device for node 1:8 ...
Creating device for node 1:7 ...
Creating device for node 1:6 ...
Creating device for node 1:5 ...
Creating device for node 1:4 ...
Creating device for node 1:3 ...
Creating device for node 1:2 ...
Creating device for node 1:1 ...
Creating device for node 1:0 ...
**Warning** The following utility(ies) failed to execute:
  sginfo
Some information may be missing.

PCI [sata_nv] 00:08.0 IDE interface: NVIDIA Corporation MCP61 SATA Cont=
roller (rev a2)
=E2scsi 0:0:0:0 ATA      WDC WD10EFRX-68P {WD-WCC4JF2PUS6H}
=E2=E2sda 931.51g [8:0] Empty/Unknown
=E2 =E2sda1 8.39g [8:1] MD raid1 (0/2) (w/ sdb1) in_sync {48eb05e3-21ad=
-decc-1633-11b2aa4e0d37}
=E2 =E2=E2md0 8.00g [9:0] MD v0.90 raid1 (2) clean {e305eb48:ccdead21:b=
2113316:370d4eaa}
=E2 =E2 =E2               ext3 {c9da1652-6fb4-4d70-91ed-e5f8aacf00da}
=E2 =E2 =E2Mounted as /dev/root @ /
=E2 =E2sda2 1.87g [8:2] swap
=E2 =E2sda3 921.25g [8:3] PV linux_raid_member 84.00G used, 604.64G fre=
e {efP9J0-elVh-1bok-dArX-cwsC-B0KW-0Yy9Ya}
=E2  =E2VG vg_gateway 688.64G 604.64G free {3grrBQ-YewZ-561L-TjEZ-agCR-=
d4zc-euFzDt}
=E2   =E2dm-2 60.00g [253:2] LV lv_data ext3 {7d168761-8de3-41ef-a037-a=
212bd4bec58}
=E2   =E2=E2Mounted as /dev/vg_gateway/lv_data @ /data
=E2   =E2dm-0 12.00g [253:0] LV lv_home ext3 {19fa9433-1692-4a07-a2c9-2=
f6d68f01fe5}
=E2   =E2=E2Mounted as /dev/vg_gateway/lv_home @ /home
=E2   =E2dm-1 12.00g [253:1] LV lv_var ext3 {a3a2776c-abd5-4c5f-bbe7-08=
a984a266c5}
=E2    =E2Mounted as /dev/vg_gateway/lv_var @ /var
=E2scsi 1:0:0:0 ATA      WDC WD10EFRX-68P {WD-WCC4J8A6V0FW}
 =E2sdb 931.51g [8:16] Empty/Unknown
  =E2sdb1 8.39g [8:17] MD raid1 (1/2) (w/ sda1) in_sync {48eb05e3-21ad-=
decc-1633-11b2aa4e0d37}
  =E2=E2md0 8.00g [9:0] MD v0.90 raid1 (2) clean {e305eb48:ccdead21:b21=
13316:370d4eaa}
  =E2                 ext3 {c9da1652-6fb4-4d70-91ed-e5f8aacf00da}
  =E2sdb2 1.87g [8:18] swap
  =E2sdb3 921.25g [8:19] MD raid1 (1/2) (w/ sda3) in_sync {558c277b-3d2=
5-4206-7863-817f31e6d691}
   =E2md1 688.64g [9:1] MD v0.90 raid1 (2) clean {7b278c55:0642253d:7f8=
16378:91d6e631}
    =E2                 PV LVM2_member (inactive)
    =E2dm-0 12.00g [253:0] LV lv_home ext3 {19fa9433-1692-4a07-a2c9-2f6=
d68f01fe5}
PCI [sata_nv] 00:08.1 IDE interface: NVIDIA Corporation MCP61 SATA Cont=
roller (rev a2)
=E2scsi 3:0:0:0 ATAPI    iHAS124   B
 =E2sr0 1.00g [11:0] Empty/Unknown
Other Block Devices
=E2ram0 16.00m [1:0] Empty/Unknown
=E2ram1 16.00m [1:1] Empty/Unknown
=E2ram2 16.00m [1:2] Empty/Unknown
=E2ram3 16.00m [1:3] Empty/Unknown
=E2ram4 16.00m [1:4] Empty/Unknown
=E2ram5 16.00m [1:5] Empty/Unknown
=E2ram6 16.00m [1:6] Empty/Unknown
=E2ram7 16.00m [1:7] Empty/Unknown
=E2ram8 16.00m [1:8] Empty/Unknown
=E2ram9 16.00m [1:9] Empty/Unknown
=E2ram10 16.00m [1:10] Empty/Unknown
=E2ram11 16.00m [1:11] Empty/Unknown
=E2ram12 16.00m [1:12] Empty/Unknown
=E2ram13 16.00m [1:13] Empty/Unknown
=E2ram14 16.00m [1:14] Empty/Unknown
=E2ram15 16.00m [1:15] Empty/Unknown

looks weird, obviously some charset problem, hope that all the needed
information is there anyway.

tnx & cu

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
