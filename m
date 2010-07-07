From: =?UTF-8?B?VMOzdGggQ3NhYmE=?= <csaba.toth@i3rendszerhaz.hu>
Subject: Re: convert raid10 to raid0
Date: Thu, 08 Jul 2010 00:51:31 +0200
Message-ID: <4C3504F3.7090108@i3rendszerhaz.hu>
References: <4C34D5AD.5020305@i3rendszerhaz.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C34D5AD.5020305@i3rendszerhaz.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010.07.07. 21:29 keltez=C3=A9ssel, T=C3=B3th Csaba =C3=ADrta:
> Hey List,
>=20
> [...]

my mdadm -E:

minerva ~ # mdadm -E /dev/sdc6
/dev/sdc6:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : a73f5902:accc2488:aecfdc14:05a6e2f4
           Name : minerva:5  (local to host minerva)
  Creation Time : Thu Nov 26 14:50:07 2009
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 1434619910 (684.08 GiB 734.53 GB)
     Array Size : 2869239808 (1368.16 GiB 1469.05 GB)
  Used Dev Size : 1434619904 (684.08 GiB 734.53 GB)
    Data Offset : 592 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : a8f10e59:dbf96c47:4c4eb9bd:2db4c161

    Update Time : Wed Jul  7 10:34:32 2010
       Checksum : df7a8ba6 - correct
         Events : 0

         Layout : near=3D2
     Chunk Size : 512K

   Device Role : spare
   Array State : ...A ('A' =3D=3D active, '.' =3D=3D missing)

minerva ~ # mdadm -E /dev/sdd6
/dev/sdd6:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : a73f5902:accc2488:aecfdc14:05a6e2f4
           Name : minerva:5  (local to host minerva)
  Creation Time : Thu Nov 26 14:50:07 2009
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 1434620238 (684.08 GiB 734.53 GB)
     Array Size : 2869239808 (1368.16 GiB 1469.05 GB)
  Used Dev Size : 1434619904 (684.08 GiB 734.53 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 2536b63d:4cb4de23:1b8e3157:f4031701

    Update Time : Wed Jul  7 10:34:32 2010
       Checksum : d99dda94 - correct
         Events : 3981420

         Layout : near=3D2
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : ...A ('A' =3D=3D active, '.' =3D=3D missing)


thanks in advance,
Csaba
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
