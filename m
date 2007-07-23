From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFH] Partition table recovery
Date: Mon, 23 Jul 2007 09:48:35 -0400
Message-ID: <20070723134835.GC19927@thunk.org>
References: <200707200813.03553.a1426z@gawab.com> <200707201429.34419.a1426z@gawab.com> <20070720113914.GJ22998@lug-owl.de> <200707201522.17270.a1426z@gawab.com> <20070720160614.GG26752@thunk.org> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <46A31F55.2000009@gmail.com> <20070722163934.GB20174@thunk.org> <46A45A01.5050709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46A45A01.5050709@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rene Herman <rene.herman@gmail.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 23, 2007 at 09:34:25AM +0200, Rene Herman wrote:
> 
> The most profound issue is _what_ to save. I for example don't cylinder 
> align my partitions (I hate wasting disk just to appease broken software) 
> meaning that not all my end_head/sector values are consistent even at the 
> best of times. Admittedly, I'm terminally analy retentive.
> 
> Exactly. This is why I earlier said that really the only functional thing 
> to do is not try to be smart and just grab things verbatim. This ofcourse 
> does hinge on one's view of "good enough"...

Heh.  Well, my definition of "good enough" is enough so that the C/H/S
fields are sane so that the BIOS can boot the system.  So I don't care
about grabbing things verbatim since my higher priority is stuffing as
much data for as many partitions as possible into 512 bytes.  Things
that require grabbing the C/H/S fields verbatim to avoid breakage I
would classify as "broken software".  But, your mileage may vary.  :-)

> That's not quite correct. Logicals have a start field relative to the 
> encompassing extended (ie, for me always 1, for others often always 63) and 
> the encompassing extended are relative not to the previous extended but to 
> the level 0 extended (the one in the MBR). 

This assumes that the extended partition is at the beginning of the
disk, yes?  Why would anyone do that?  I normally have /dev/hda1 at
the beginning of the disk, and I normally make /dev/hda4 my extended,
and place it *after* partitions at /dev/hda2, /dev/hda3, etc.

> So at most you get can 32-bit + 32-bit which could, yeah, in principle 
> overflow into the 32nd bit -- it normally won't ofcourse since the start 
> field, being relative, will be small, and I'd expect quite a few bits of 
> software to break on this condition.

It would be interesting to see how badly modern Windows systems breaks
on this.  If Windows 2000 and above works, and Linux works, then if
other things break it might be quite sufficient to consider them
"broken software" that we don't need to worry about.

> With 32-bit values (and 512-byte sectors) you can service 2TB -- anything 
> above that requires something better than MS-DOS partition tables. 

Well, in about 2-3 years or so we'll seeing having singleton disks
bigger 2TB.  I'm not terribly sanguine about BIOS vendors and OS
providers migrating to something better by then, alas.  Life is sure
going to be interesting.  :-)

						- Ted
