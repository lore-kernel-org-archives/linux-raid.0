From: Neil Brown <neilb@suse.de>
Subject: Re: Failed create or resync - incorrect checksums
Date: Thu, 17 Aug 2006 10:54:21 +1000
Message-ID: <17635.48701.271861.882129@cse.unsw.edu.au>
References: <147d2b050608161655v45735d17i14dc764afed10d70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Richard Taylor on Wednesday August 16
Sender: linux-raid-owner@vger.kernel.org
To: Richard Taylor <ryo.away@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 16, ryo.away@gmail.com wrote:
> Hello,
> 
> I have been trying to get a raid5 array going on SuSE 10.1 Final
> (2.6.16.21-0.13-default) but every time I create, resync, or rebuild a
> spare it seems to have worked, but
> 
>     # mdadm --examine /dev/sd[bcd]1
> 
> gives a report that the checksum is off:
> 
>     /dev/sdb1:
...
>            Checksum : 4a95604a - expected 4a955f4e

Weird.... does this happen for all drives?

> 
> Furthermore, I can work with the array at this point and it seems to
> be ok unless I were to reboot or stop and re-assemble it:
> 
>     # mdadm --assemble /dev/md1
>     mdadm: failed to add /dev/sdc1 to /dev/md1: Invalid argument
>     mdadm: failed to add /dev/sdd1 to /dev/md1: Invalid argument
>     mdadm: failed to add /dev/sdb1 to /dev/md1: Invalid argument
>     mdadm: /dev/md1 assembled from 0 drives - not enough to start the array.
> 
> I've tried to assemble with --update=resync, super-minor, or
> summaries.  The latter two seem to work, but the data on the array has
> become corrupt as a result.  I would greatly appreciate any help
> anybody could give.

This shouldn't corrupt the array...
I'd be very suspicious of your hardware, whether controller cabling or
drives..

It really looks like you aren't getting back what you wrote out.

Can you try creating a filesystem on just one drive, copy some very
larges files into it, and the sha1sum the files to make sure they
haven't changed.

NeilBrown
