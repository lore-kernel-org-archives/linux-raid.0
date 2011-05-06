From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 11:03:45 +0200
Message-ID: <20110506090345.GA22245@www2.open-std.org>
References: <20110506071752.GA22063@www2.open-std.org> <20110506133159.30c66519@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110506133159.30c66519@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 06, 2011 at 01:31:59PM +0600, Roman Mamedov wrote:
> On Fri, 6 May 2011 09:17:52 +0200
> Keld J=F8rn Simonsen <keld@keldix.com> wrote:
>=20
> > I would like linux MD raid10 functionality to be part of the Linux =
MD
> > RAID1 module, and be called raid1. This is in accordance with the
> > use of the RAID1 term as standadized by SNIA. In fact the RAID10-of=
fset
> > layout is an implementation of a SNIA RAID specification. The RAID1=
0-near
> > layout is an implementation of a simple RAID layout. And the RAID10=
-far
> > layout is just another layout far a mirrored RAID.  So all these ty=
pes
> > could just be defined as different RAID1 layouts.
>=20
> RAID1 is RAID1, RAID10 is RAID10.
> RAID1 on 4 drives is very different from RAID10 on 4 drives.
> Don't add confusion by trying to rename RAID10 to RAID1.

How are they different?
Say what is the difference between a Linux MD RAID1 with 4 disks, and
the default Linux MD RAID10 with 4 disks? (in the near layout)?

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
