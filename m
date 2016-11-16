From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: recovering failed raid5
Date: Wed, 16 Nov 2016 12:14:07 +0100
Message-ID: <20161116111407.GA3348@metamorpher.de>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133626.GA27462@cthulhu.home.robinhill.me.uk>
 <194ae464-2d19-cefd-055f-6f4a33676ab2@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <194ae464-2d19-cefd-055f-6f4a33676ab2@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 16, 2016 at 09:04:29AM +0000, Alexander Shenkin wrote:
> I'm getting a 'No space left on device error'.  Any thoughts?

It's smaller by 4096 bytes, that's probably not a problem. 
ddrescue seems to have failed to copy 128K of data, 
but that's probably not a big problem either.

Your problem is something else:

> Disk /dev/sdb: 2.7 TiB, 3000592982016 bytes, 5860533168 sectors
> Sector size (logical/physical): 512 bytes / 512 bytes
> Disklabel type: gpt

> Disk /dev/sdc: 2.7 TiB, 3000592977920 bytes, 732566645 sectors
> Sector size (logical/physical): 4096 bytes / 4096 bytes
> Disklabel type: dos

The physical sector size is different.

Unfortunately GPT partition scheme still depends on sector size and is 
inherently incompatible when dd(rescue)'d to a drive with different size.

In theory it would be possible to ignore this, i.e. interpret GPT 
correctly on a 4K sector drive even if it was created for a 512b drive, 
or vice versa, but Linux is quite strict about standards in this case. 
(If Linux was smarter it would work in Linux but fail for Windows...)

Anyway, you'll have to fixer-upper your GPT partition tables to 4K. 
gdisk has an expert -> recovery section that might be able to do so 
automagically, or you could just manually recreate with the correct 
_byte_ offsets (sector offset will be different).

Your partitions are all MiB aligned so there are no alignment issues.

Once the partition table is fixed you should be able to proceed normally.

Regards
Andreas Klauer
