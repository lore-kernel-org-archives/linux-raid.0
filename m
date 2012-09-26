From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Wed, 26 Sep 2012 14:17:42 +0200
Message-ID: <5315095.pvR2SvTGWe@techz>
References: <4961154.0TR9MeFlIq@techz> <5231765.ZMIFzBOKSc@techz> <FABB1E4C-1CAC-429F-96CF-FC563336A913@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FABB1E4C-1CAC-429F-96CF-FC563336A913@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Chris,

Am Dienstag, 25. September 2012, 10:55:39 schrieb Chris Murphy:
> On Sep 25, 2012, at 2:27 AM, G=FCnther J. Niederwimmer wrote:
> >    Dirty State : dirty
>=20
> Basically this is my only remaining concern, and while I don't know w=
hy it's
> dirty, I think it needs to be resolved if you care about having RAID =
1 in
> the first place. My best guess is that neither md on Linux nor the IM=
SM
> driver on Windows have an unambiguous way to determine which disk is
> correct, which is why it hasn't just sync'd them. So you kinda have t=
o pick
> one (?) and force a sync - again I'll have to defer to someone else t=
o
> answer that question but it's probably not ideal to just leave it in =
a
> dirty state.
=20
OK, I run the Intel Tool in windows two times with the last Tool I foun=
d.

The Tool don't found any Problem (?) and don't repair, but mdadm....

/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.1.00
    Orig Family : e3958f4b
         Family : e3958f4b
     Generation : 00019ef2
     Attributes : All supported
           UUID : 363f146f:e7f29dc8:f05996c3:577ead6a
       Checksum : 3e8b1bfe correct
    MPB Sectors : 1
          Disks : 2
   RAID Devices : 1

  Disk00 Serial : 6QF4WDE3
          State : active
             Id : 00000000
    Usable Size : 625137928 (298.09 GiB 320.07 GB)

[Volume0]:
           UUID : ec120401:b6ed52e6:3814fac4:48fcf4fc
     RAID Level : 1
        Members : 2
          Slots : [UU]
    Failed disk : none
      This Slot : 0
     Array Size : 625137664 (298.09 GiB 320.07 GB)
   Per Dev Size : 625137928 (298.09 GiB 320.07 GB)
  Sector Offset : 0
    Num Stripes : 2441944
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean

  Disk01 Serial : 6QF4WF5Z
          State : active
             Id : 00000001
    Usable Size : 625137928 (298.09 GiB 320.07 GB)

/dev/sdb:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.1.00
    Orig Family : e3958f4b
         Family : e3958f4b
     Generation : 00019f47
     Attributes : All supported
           UUID : 363f146f:e7f29dc8:f05996c3:577ead6a
       Checksum : 3e8c1c53 correct
    MPB Sectors : 1
          Disks : 2
   RAID Devices : 1

  Disk01 Serial : 6QF4WF5Z
          State : active
             Id : 00000001
    Usable Size : 625137928 (298.09 GiB 320.07 GB)

[Volume0]:
           UUID : ec120401:b6ed52e6:3814fac4:48fcf4fc
     RAID Level : 1
        Members : 2
          Slots : [UU]
    Failed disk : none
      This Slot : 1
     Array Size : 625137664 (298.09 GiB 320.07 GB)
   Per Dev Size : 625137928 (298.09 GiB 320.07 GB)
  Sector Offset : 0
    Num Stripes : 2441944
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : dirty
                 =B0=B0=B0=B0=B0=B0=B0

  Disk00 Serial : 6QF4WDE3
          State : active
             Id : 00000000
    Usable Size : 625137928 (298.09 GiB 320.07 GB)

=20
--=20
mit freundlichen Gr=FC=DFen / best Regards.

  G=FCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
