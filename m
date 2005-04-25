From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid 10 or 1+0 ?
Date: Mon, 25 Apr 2005 17:49:37 -0400
Message-ID: <200504252149.j3PLngm00560@www.watkins-home.com>
References: <62b0912f050425130869cff461@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f050425130869cff461@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Molle Bestefich' <molle.bestefich@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is from an email Neil Brown sent 8/22/2004:
Following are 4 patches for md in 2.6.8.1-mm4

The first three are minor improvements and modifications either
required by or inspired by the fourth.

The fourth adds a new raid personality - raid10.  At 56K, I'm not 
sure it will get through the mailing list, but interested parties
can find it at:

  http://neilb.web.cse.unsw.edu.au/patches/linux-devel/2.6/2004-08-23-03

raid10 provides a combination of raid0 and raid1.
It requires mdadm 1.7.0 or later to use.  

The next release of mdadm should have better documention of raid10, but 
from the comment in the .c file:

/*
 * RAID10 provides a combination of RAID0 and RAID1 functionality.
 * The layout of data is defined by 
 *    chunk_size
 *    raid_disks
 *    near_copies (stored in low byte of layout)
 *    far_copies (stored in second byte of layout)
 *
 * The data to be stored is divided into chunks using chunksize.
 * Each device is divided into far_copies sections.
 * In each section, chunks are layed out in a style similar to raid0, but
 * near_copies copies of each chunk is stored (each on a different drive).
 * The starting device for each section is offset near_copies from the
starting
 * device of the previous section.
 * Thus there are (near_copies*far_copies) of each chunk, and each is on a
different
 * drive.
 * near_copies and far_copies must be at least one, and there product is at
most
 * raid_disks.
 */

raid10 is currently marked EXPERIMENTAL, and this should be taken seriously.
A reasonable amount of basic testing hasn't shown any bugs, and it seems to
resync
and rebuild correctly.  However wider testing would help.

NeilBrown

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Molle Bestefich
> Sent: Monday, April 25, 2005 4:08 PM
> To: linux-raid@vger.kernel.org
> Subject: Re: raid 10 or 1+0 ?
> 
> Molle Bestefich wrote:
> > Guy wrote:
> > > md supports a built-in RAID10.
> > > RAID10 can be used with an odd number of disks and is a single array.
> >
> > *sighs a bit*..
> [snip]
> 
> Doesn't look that bad actually.  There's a vendor section called
> "proprietary raid levels" where "Linux MD RAID 10" would fit in
> nicely.  So if anybody knows enough about how MD RAID 10 works, here's
> something to do when you get bored :-).
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

