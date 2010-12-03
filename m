From: Neil Brown <neilb@suse.de>
Subject: Re: RAID-5 implementation questions
Date: Fri, 3 Dec 2010 22:08:07 +1100
Message-ID: <20101203220807.68ce9f58@notabene.brown>
References: <4CF8AF30.5070505@ka9q.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF8AF30.5070505@ka9q.net>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Karn <karn@ka9q.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 03 Dec 2010 00:49:52 -0800 Phil Karn <karn@ka9q.net> wrote:

> Are there any papers documenting the implementation of the Linux RAID
> subsystem? I'm interested in some of the details of how RAID-5 works.

I would suggest
  man mdadm
and
  man md

That should answer at least some of your questions.

Then try  http://raid.wiki.kernel.org/

If you have further questions after that, please ask.

NeilBrown


> 
> I've never seen a virgin disk drive from the factory that wasn't all
> 0's. Creating a RAID array on a set of such drives triggers an initial
> rebuild that simply writes lots zeroes on lots of zeroes. With disks now
> pushing past 2 TB, this can easily take half a day.
> 
> Except for the admittedly somewhat useful side effect of scanning the
> disks for bad sectors, all this activity seems rather unnecessary. Is
> there a way to create a RAID-5 (or any other RAID level) array so that
> it will immediately come up without an initial rebuild?
> 
> File systems generally don't read disk blocks that they haven't already
> written. So even when you build a RAID array from drives with old data,
> I can't see how skipping the initial rebuild can cause any real harm.
> The first write to any block causes the RAID system to initialize the
> parity in that stripe, thus making it possible to regenerate that block
> in case of a drive failure.
> 
> During the initial rebuild of a RAID-5 array, /proc/mdstat suggests that
> the array is operating in degraded mode and the last drive in the array
> is being rebuilt. Is this true, i.e., are all the rebuild writes going
> to that last drive?
> 
> How does a rebuilding RAID-5 array handle a read or write operation when
> it lands on the "broken" drive? Does it depend on whether the block is
> before or after the rebuild pointer?
> 
> Thanks much,
> 
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

