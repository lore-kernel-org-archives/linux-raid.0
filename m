From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: reconstructing raid5 with bad sectors
Date: Mon, 4 Aug 2003 14:14:15 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030804181415.GA3575@willow.seitz.com>
References: <Pine.LNX.4.53.0308041002360.21796@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0308041002360.21796@twinlark.arctic.org>
To: dean gaudet <dean-list-linux-raid@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Aug 04, 2003 at 10:08:15AM -0700, dean gaudet wrote:
> is there an offline tool which can reconstruct such an array?  or even an
> offline tool which already has the parity calculation code and such which
> i could extend to support such reconstruction?
> 
> i considered copying the two bad disks with "dd conv=noerror,sync", which
> would stop the kernel from marking the drives as bad, but that seems a bit
> less than ideal because i really would like to reconstruct the bad stripes
> using the 3 valid copies and not include an all-zeroes copy created by dd.

dd_rescue sounds like your friend - it'll let you make raw backups of
the partitions, but instead of quitting on errors, it'll keep going
until it passes the bad areas.  You'll probably need a few disks to use
as dd_rescue targets, but once you have images of the needed partitions,
rebuild should work fine (assuming of course, that you're correct in saying
the errors never overlap).

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
