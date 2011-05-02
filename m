From: "Peter Kovari" <peter@kovari.priv.hu>
Subject: RE: Question regarding --backup-file
Date: Mon, 2 May 2011 19:39:59 +0200
Message-ID: <001501cc08ef$f60cc620$e2265260$@priv.hu>
References: <000301cc08db$89293160$9b7b9420$@priv.hu> <4DBECEFA.1050203@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DBECEFA.1050203@fnarfbargle.com>
Content-Language: hu
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Hi all,
> >
> > I understand, that a change from RAID5 to RAID6 by adding a single disk
-
> > eg. keeping the number of data disks - requires a backup file throughout
the
> > whole reshape process. For a larger, multi-TB array this means millions
of
> > writes to the backup file, which - if i'm correct - means means millions
of
> > writes to the same physical sectors of the disk that holds the backup
file.
> > Is this not problematic? How many write operations can a typical drive
> > tolerate nowadays? (on the same sectors)

> Lots, where Lots >= 1 and Lots < infinity.

> I've never seen rotating media specify any form of limitation to writes. 
> Have you?

No, that's why i'm asking. 

Imho, in typical usage, write cycle counts on a certain sector may not be
that high, even on a database server. I doubt it ever goes over a few
hundred thousands during the life cycle of the hard disk. On the other hand,
a single reshape on a larger array can trigger tens of millions of write
cycles on certain sectors. Sectors do fail eventually, so I'm wondering if
the "no limit" is truly a no limit, or manufacturers just won't state this
info because in "normal" usage, customers will never reach that limit.

Btw, i'm sure SSD's are not meant to take such a pressure.

Cheers,
Peter


