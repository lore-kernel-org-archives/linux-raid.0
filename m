From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 17:24:06 +0200
Message-ID: <20110506152405.GB22964@www2.open-std.org>
References: <20110506071752.GA22063@www2.open-std.org> <20110506133159.30c66519@natsu> <20110506090345.GA22245@www2.open-std.org> <4DC3BDD9.1060300@abpni.co.uk> <20110506094102.GC22245@www2.open-std.org> <20110506155059.6f82cbeb@natsu> <4DC3C804.6080200@abpni.co.uk> <iq0jv1$psl$1@dough.gmane.org> <20110506132739.GA22689@www2.open-std.org> <4DC3FF4C.5090502@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DC3FF4C.5090502@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 06, 2011 at 10:01:48AM -0400, Miles Fidelman wrote:
> Keld J=F8rn Simonsen wrote:
> >>As you say, RAID10,near on four disks is pretty much identical to
> >>RAID1+0 - i.e., a stripe of two normal RAID1 pairs.
> >>    =20
>=20
> I don't that's exactly right.  At least as I understand it:
>=20
> - RAID1+0 (and RAID0+1) nests things - you start with two sets of RAI=
D1=20
> mirrors, then stripe across them (or vice versa) - it's a nested set =
of=20
> steps
>=20
> - md RAID10 provides both mirroring and striping, but it's a more=20
> integrated function - (from the man page) "RAID10 provides a combinat=
ion=20
> of RAID1 and RAID0, and sometimes known as RAID1+0. Every datablock i=
s=20
> duplicated some number of times, and the resulting collection of=20
> datablocks are distributed over multiple drives." - but there isn't a=
n=20
> inherent nesting in the process (i.e., no two disks are copies of eac=
h=20
> other, and md RAID10 will work over odd numbers of drives)

Yes, you are right, RAID1+0 is nested, while Linux MD raid10 is not.
But the data layout of Linux MD RAID1+0 and Linux MD
RAID10,near is almost identical.

keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
