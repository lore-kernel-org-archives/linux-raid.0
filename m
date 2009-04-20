From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: what superblock to use
Date: Mon, 20 Apr 2009 14:39:05 -0500
Message-ID: <20090420193914009.EBTN9976@cdptpa-omta03.mail.rr.com>
References: <20090420141702.GC17461@maude.comedia.it>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090420141702.GC17461@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> >what's the current recommended superblock to use for a newly created
> >raid5-6 array with 6 pieces of 1tb disk? by default mdamd use 0.90. is
> >it worth to change it to any 1.x format?
> 0.9 has some limitations that 1.x do not have, none apply in your case
> max_components = 28
> max_size of component=2TB

Oops!  I did not realize this when I built my array.  I'm going to need to
grow the array to 3T components after the 3T drives are released.  Can the
superblock be changed on an existing array, or does it have to be rebuilt
from scratch?  If the latter, I'm glad I learned this now, because I may
have to rebuild the array, anyway, to try to alleviate the halt issue I am
experiencing.


