From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: I just trashed my RAID5 array - recovery possible?
Date: Thu, 20 Mar 2003 08:34:56 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030320133455.GA29878@willow.seitz.com>
References: <20030320000358.ALLYOURBASEAREBELONGTOUS.A6336@bla.fasel.org> <15993.2378.97234.342504@notabene.cse.unsw.edu.au> <20030320075133.ALLYOURBASEAREBELONGTOUS.B4264@bla.fasel.org> <15993.36889.254497.789214@notabene.cse.unsw.edu.au> <20030320122227.ALLYOURBASEAREBELONGTOUS.G4264@bla.fasel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030320122227.ALLYOURBASEAREBELONGTOUS.G4264@bla.fasel.org>
To: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 20, 2003 at 01:22:27PM +0100, Wolfram Schlich wrote:
> I've put up the logfile of fsck at
> http://wolfram.schlich.org/tmp/fsck.log.1
> I have no idea whether this is an "uncomfortable large amount of
> damage", so would you mind having a look at it? :-) TIA!

That's a pretty huge amount of damage.  If fsck is able to fix it
without trashing data, then it doesn't matter.  I missed how big your
array was, but if you have the resources to make an image of the raw
devices, I'd definately reccomend you do so:

# cat /dev/hdx > /some/path/with/lots/of/space/hdx.img

This will let you restore your disks and try again.  At any rate, good
luck with the data.

-- 
Ross Vandegrift
ross@willow.seitz.com

A Pope has a Water Cannon.                               It is a Water Cannon.
He fires Holy-Water from it.                        It is a Holy-Water Cannon.
He Blesses it.                                 It is a Holy Holy-Water Cannon.
He Blesses the Hell out of it.          It is a Wholly Holy Holy-Water Cannon.
He has it pierced.                It is a Holey Wholly Holy Holy-Water Cannon.
He makes it official.       It is a Canon Holey Wholly Holy Holy-Water Cannon.
Batman and Robin arrive.                                       He shoots them.
