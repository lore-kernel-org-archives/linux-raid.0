From: Neil Brown <neilb@suse.de>
Subject: Re: data recovery on raid5
Date: Sun, 23 Apr 2006 12:46:38 +1000
Message-ID: <17482.60046.999713.487183@cse.unsw.edu.au>
References: <444A7C99.80006@abhost.net>
	<62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Saturday April 22
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: Jonathan <jrs@abhost.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 22, molle.bestefich@gmail.com wrote:
> Jonathan wrote:
> > # mdadm -C /dev/md0 -n 4 -l 5 missing /dev/etherd/e0.[023]
> 
> I think you should have tried "mdadm --assemble --force" first, as I
> proposed earlier.
> 
> By doing the above, you have effectively replaced your version 0.9.0
> superblocks with version 0.9.2.  I don't know if version 0.9.2
> superblocks are larger than 0.9.0, Neil hasn't responded to that yet. 
> Potentially hazardous, who knows.

There is no difference in the superblock between 0.90.0 and 0.90.2.

md has always used version numbers, but always in a confusing way.
There should be two completely separate version numbers: the version
for the format of the superblock, and the version for the software
implementation.  md confuses these two.

To try to sort it out, I have decided that:
 - The 'major' version number is the overall choice of superblock
    This is currently 0 or 1
 - The 'minor' version encodes minor variation in the superblock.
    For version 1, this is different locations (there are other bits
    in the superblock to allow new fields to be added)
    For version 0, it is currently only used to make sure old software
      doesn't try to assemble an array which is undergoing a
      shape, as that would confuse it totals.

 - The 'patchlevel' is used to indicate feature availability in
   the implementation.  It really should be stored in the superblock,
   but it is for historical reasons.  It is not checked when
   validating a superblock.
  To quote from md.h

/*
 * MD_PATCHLEVEL_VERSION indicates kernel functionality.
 * >=1 means different superblock formats are selectable using SET_ARRAY_INFO
 *     and major_version/minor_version accordingly
 * >=2 means that Internal bitmaps are supported by setting MD_SB_BITMAP_PRESENT
 *     in the super status byte
 * >=3 means that bitmap superblock version 4 is supported, which uses
 *     little-ending representation rather than host-endian
 */

Hope that helps.

NeilBrown
