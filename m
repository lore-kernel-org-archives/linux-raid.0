From: Tom De Mulder <tdm27@cam.ac.uk>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 12:10:29 +0100 (BST)
Message-ID: <alpine.OSX.2.00.1106291206390.257@trogdor.csi.cam.ac.uk>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com> <alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk> <20110629204519.419474d2@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110629204519.419474d2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jun 2011, NeilBrown wrote:

> It is not at all straight forward to implement.
>
> For stripe/parity RAID, (RAID4/5/6) it is only safe to discard full stripes at
> a time, and the md layer would need to keep a record of which stripes had been
> discarded so that it didn't risk trusting data (and parity) read from those
> stripes.  So you would need some sort of bitmap of invalid stripes, and you
> would need the fs to discard in very large chunks for it to be useful at all.
>
> For copying RAID (RAID1, RAID10) you really need the same bitmap.  There
> isn't the same risk of reading and trusting discarded parity, but a resync
> which didn't know about discarded ranges would undo the discard for you.

However, that might not necessarily be a problem; tools exist that can be 
run manually (slightly fsck-like) and tell the drive which blocks can be 
erased.

> So: do-able, but definitely non-trivial.

Thanks very much for your response, you make some very good points.

I shall, for the time being, chop my SSDs in half and let them treat the 
empty half as spare area, which should make performance degradation a 
non-issue. I hope.


Cheers,

--
Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Service
+44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3QH
-> 29/06/2011 : The Moon is Waning Crescent (18% of Full)
