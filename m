From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Reason for md raid 01 blksize limited to 4 KiB?
Date: Wed, 30 May 2012 15:03:16 +0200
Message-ID: <4FC61A94.3050605@profitbricks.com>
References: <4FBA0047.5050208@profitbricks.com>	<20120522092817.1b5946b8@notabene.brown>	<4FBF7CAD.7000307@profitbricks.com>	<20120528140505.6eb49b26@notabene.brown>	<4FC49733.9050905@profitbricks.com> <20120529202559.6aa7fd49@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120529202559.6aa7fd49@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/05/12 12:25, NeilBrown wrote:
> On Tue, 29 May 2012 11:30:27 +0200 Sebastian Riemer
> <sebastian.riemer@profitbricks.com> wrote:
>> Now, I've updated mdadm to version 3.2.5 and it works like you've
>> described it. Thanks for your help! But the buffered IO is what matters.
>> 4k isn't enough there. Please inform me about changes which increase the
>> size in buffered IO. I'll have a look at this, too.
> 
> I don't know.  I'd have to dive into the code and look around and put a few
> printks in to see what is happening.

Now, I've configured a storage server with real HDDs for testing the
cached IO with kernel 3.4. Here direct IO always doesn't work
(Input/Output error with dd/fio). And cached IO is totally slow. My
RAID0 devices are md100 and md200. The RAID1 on top is the md300.

The md100 is reported as "faulty spare" and this has hit the following a
kernel bug.

This is the debug output:

md/raid0:md100: make_request bug: can't convert block across chunks or
bigger than 512k 541312 320
md/raid0:md200: make_request bug: can't convert block across chunks or
bigger than 512k 541312 320
md/raid1:md300: Disk failure on md100, disabling device.
md/raid1:md300: Operation continuing on 1 devices.
RAID1 conf printout:
--- wd:1 rd:2
disk 0, wo:1, o:0, dev:md100
disk 1, wo:0, o:1, dev:md200
RAID1 conf printout:
--- wd:1 rd:2
disk 1, wo:0, o:1, dev:md200
md/raid0:md200: make_request bug: can't convert block across chunks or
bigger than 512k 2704000 320

The chunk size of 320 KiB comes from max_sectors_kb of the LSI HW RAID
controller where the drives are passed through as single drive RAID0
logical devices. I guess this is a problem for MD RAID0 underneath the
RAID1, because this doesn't fit as a multiple of the 512 KiB stripe size.

Cheers,
Sebastian
