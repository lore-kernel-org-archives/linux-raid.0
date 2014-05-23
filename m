From: "Liu H.T" <liuhongtong86@gmail.com>
Subject: Invalid bitmap file superblock: bad magic
Date: Fri, 23 May 2014 11:40:24 +0800
Message-ID: <CAMKi=TGdeaLZ4y0fSDeXTEzkLjoYzq9L=7Y91nyciX3p3ndWzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

A RAID5 array of 14 disks failed to be assembled with command mdadm -A
-f -s, but everything is well before system reboot.

Log in /var/log/dmesg
md: md0 stopped.
md: bind<sdq>
md: bind<sdm>
md: bind<sde>
md: bind<sdg>
md: bind<sdc>
md: bind<sdb>
md: bind<sdh>
md: bind<sdf>
md: bind<sdd>
md: bind<sdl>
md: bind<sdk>
md: bind<sdp>
md: bind<sdi>
md: bind<sdn>
md: bind<sdj>
md: bind<sdo>
async_tx: api initialized (async)
xor: automatically using best checksumming function: generic_sse
   generic_sse: 14476.000 MB/sec
xor: using function: generic_sse (14476.000 MB/sec)
raid6: int64x1   3917 MB/s
raid6: int64x2   4234 MB/s
raid6: int64x4   3507 MB/s
raid6: int64x8   2855 MB/s
raid6: sse2x1    8937 MB/s
raid6: sse2x2   10960 MB/s
raid6: sse2x4   13027 MB/s
raid6: using algorithm sse2x4 (13027 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: device sdo operational as raid disk 0
raid5: device sdi operational as raid disk 13
raid5: device sdp operational as raid disk 12
raid5: device sdk operational as raid disk 11
raid5: device sdl operational as raid disk 10
raid5: device sdd operational as raid disk 9
raid5: device sdf operational as raid disk 8
raid5: device sdh operational as raid disk 7
raid5: device sdb operational as raid disk 6
raid5: device sdc operational as raid disk 5
raid5: device sdg operational as raid disk 4
raid5: device sde operational as raid disk 3
raid5: device sdm operational as raid disk 2
raid5: device sdq operational as raid disk 1
raid5: allocated 14802kB for md0
0: w=3D1 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
13: w=3D2 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
12: w=3D3 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
11: w=3D4 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
10: w=3D5 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
9: w=3D6 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
8: w=3D7 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
7: w=3D8 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
6: w=3D9 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
5: w=3D10 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
4: w=3D11 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
3: w=3D12 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
2: w=3D13 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
1: w=3D14 pa=3D0 pr=3D14 m=3D1 a=3D2 r=3D14 op1=3D0 op2=3D0
raid5: raid level 5 set md0 active with 14 out of 14 devices, algorithm=
 2
RAID5 conf printout:
--- rd:14 wd:14
disk 0, o:1, dev:sdo
disk 1, o:1, dev:sdq
disk 2, o:1, dev:sdm
disk 3, o:1, dev:sde
disk 4, o:1, dev:sdg
disk 5, o:1, dev:sdc
disk 6, o:1, dev:sdb
disk 7, o:1, dev:sdh
disk 8, o:1, dev:sdf
disk 9, o:1, dev:sdd
disk 10, o:1, dev:sdl
disk 11, o:1, dev:sdk
disk 12, o:1, dev:sdp
disk 13, o:1, dev:sdi
md0: invalid bitmap file superblock: bad magic
md0: bitmap file superblock:
         magic: fe7dba0d
       version: -365720891
          uuid: 9eab97d7.9147f31f.bdd1efdc.51fc0233
        events: 44011
events cleared: 44011
         state: d11bd8fb
     chunksize: -1058286870 B
  daemon sleep: 5s
     sync size: 78776200384467208 KB
max write behind: 0
md0: failed to create bitmap (-22)


All the disks' bitmap are corrupted.
# mdadm -X /dev/sdm
        Filename : /dev/sdm
           Magic : fe7dba0d
mdadm: invalid bitmap magic 0xfe7dba0d, the bitmap file appears to be c=
orrupted
         Version : -365720891
mdadm: unknown bitmap version -365720891, either the bitmap file is
corrupted or you need to upgrade your tools

# mdadm -X /dev/sdp
        Filename : /dev/sdp
           Magic : fe7dba0d
mdadm: invalid bitmap magic 0xfe7dba0d, the bitmap file appears to be c=
orrupted
         Version : -365720891
mdadm: unknown bitmap version -365720891, either the bitmap file is
corrupted or you need to upgrade your tools


I have encounter this problem twice, but it's difficult to reappear.
Can anyone help me to resolve this problem=EF=BC=9FThank you very much.

# uname -r
2.6.32-71.el6.x86_64
# mdadm --version
mdadm - v3.2.2 - 17th June 2011
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
