From: "Jon =?iso-8859-1?Q?Lur=E5s?=" <jon@irisinfo.net>
Subject: Re: Change disk problem
Date: Sun, 08 Jun 2008 15:14:27 +0200
Message-ID: <WorldClient-F200806081514.AA14270522@irisinfo.net>
References: <S1753847AbYFHHWg/20080608072236Z+62@vger.kernel.org> <WorldClient-F200806080958.AA58320509@irisinfo.net> <484BADAF.4000605@dgreaves.com> <WorldClient-F200806081212.AA12040517@irisinfo.net> <484BC1F5.3000009@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484BC1F5.3000009@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi

I didn't check in dmesg all the time. Now I check again - and your are
correct there is a hardware problem (maybe) with my hdj. This has nothi=
ng
to do on the linux-raid list... "hdj dma_intr: status=3D0x51 { DriveRea=
dy
SeekComplete Error }"

Jon

-----Original Message-----
=46rom: David Greaves <david@dgreaves.com>
To: Jon Lur=E5s <jon@irisinfo.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Sun, 08 Jun 2008 12:26:45 +0100
Subject: Re: Change disk problem

> Jon Lur=E5s wrote:
> > Hello=20
> >=20
> > Thank you for your input.
> >=20
> > I gave to little information in the original mail. I had tried to
> 'add'
> > the new disk. It shows up like this - se below. The bad thing is th=
at
> then
> > the device '/dev/hdj1' suddenly changes to 'spare'...
> > and everything looks very bad :-(
>=20
> OK, you also wrote (forgot to cc the list)
> Jon Lur=E5s wrote:
> > Hi again
> >
> > A little more information:
> > The only solution I found to the problem which arised after the 'ad=
d'
> og
> > /dev/hdk1 is
> > "mdadm --create /dev/md0 --verbose --level=3D5 --chunk=3D64
> --raid-devices=3D3
> > /dev/hdi1 /dev/hdj1 missing"
> >
> > The it looks like the original 'mdadm --detail /dev/md0' result.
> >
> > Jon
>=20
> So I'm now quite confused.
>=20
> Can you tell us what you did a step at a time.
> This is what should have happened:
>=20
> 1 Original disk failed.
> 2 md0 went into degraded and mdadm --monitor sent you an email
> 3 you shutdown and replaced /dev/hdk (?)
> 4 you partitioned /dev/hdk to make hdk1
> 5 you used --add to add hdk1 to the array
> 6 all was well
>=20
> now you seem to have done several 'interesting' things in addition
> (like issuing
> a --create).
> However, if you can go back to the original --detail given, a simple
> --add
> should resolve your problems...
>=20
> You may want to check your dmesg to make sure you don't have a hardwa=
re
> issue.
>=20
> > demeter:/etc# mdadm --detail /dev/md0
> > /dev/md0:
> >         Version : 00.90.00
> >   Creation Time : Sat Jun  7 22:04:01 2008
> >      Raid Level : raid5
> >      Array Size : 490223232 (467.51 GiB 501.99 GB)
> >     Device Size : 245111616 (233.76 GiB 250.99 GB)
> >    Raid Devices : 3
> >   Total Devices : 4
> > Preferred Minor : 0
> >     Persistence : Superblock is persistent
> >=20
> >     Update Time : Sun Jun  8 12:05:02 2008
> >           State : active, degraded
> >  Active Devices : 1
> > Working Devices : 3
> >  Failed Devices : 1
> >   Spare Devices : 2
> >=20
> >          Layout : left-symmetric
> >      Chunk Size : 64K
> >=20
> >            UUID : 7edd5dfe:14b3ffb2:304b0607:0d821dcd
> >          Events : 0.8
> >=20
> >     Number   Major   Minor   RaidDevice State
> >        0      56        1        0      active sync   /dev/hdi1
> >        1       0        0        1      removed
> >        2       0        0        2      removed
> >=20
> >        3      57        1        3      spare   /dev/hdk1
> >        4      56       65        4      spare   /dev/hdj1
>=20
> This doesn't look good.
>=20
> what does --examine say about each of the components?
>=20
> David


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
