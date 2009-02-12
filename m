From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 10:46:04 +0100
Message-ID: <20090212094604.GA11981@rap.rap.dk>
References: <20090212031009.23983.14496.stgit@notabene.brown> <20090212081148.GD9439@rap.rap.dk> <4993E82D.1020309@fairbairn-family.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4993E82D.1020309@fairbairn-family.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Fairbairn <steve@fairbairn-family.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 12, 2009 at 09:13:17AM +0000, Steve Fairbairn wrote:
> Keld J=F8rn Simonsen wrote:
> >
> >I would rather have functionality to convert raid10 to raid5.
> >raid1 should be depreciated, as raid10,n2 for all purposes is the sa=
me
> >but better implementation and performance, and raid10,f2 and raid10,=
o2
> >are even better.  Nobody should use raid1 anymore.
> >
> Complete ignorance of raid10 here, but is raid10,<anything> bootable,=
=20
> like raid1 is?  I use raid1 on my root and boot partitions.

AFAIK, raid10,n2 in default mode (superblock etc) is bootable, as it
looks like two copies of a normal FS. I think this was even reported=20
on this list at some time.=20

You are not the only one that does not know much about raid10. I think
most Linux administrators don't.  And other system adminstrators most
likely don't either.

Maybe we should rename raid10 to raid1?

Raid10 should just be an enhanced raid1. And I understand from Neil tha=
t
raid10,o2 is mostly done because it is a standard raid1 layout. So it i=
s
strange that it is not available with raid1 in Linux. And I also think
that the raid10,f2 layout is available from some HW raid controllers, a=
s
their implementation of raid1. So all what is in raid10 is other places
considered raid1 stuff.

Or we could merge the two drivers.=20

I think we will never get people in general to know about raid10 as wel=
l
as they know about raid1, not even by far.=20

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
