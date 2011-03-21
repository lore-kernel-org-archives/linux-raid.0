From: Hari Subramanian <hari@vmware.com>
Subject: RE: Adaptive throttling for RAID1 background resync
Date: Mon, 21 Mar 2011 14:02:37 -0700
Message-ID: <10FC03A59E498D4A90A45E4A105AD3ED02EE70F9A7@EXCH-MBX-2.vmware.com>
References: <201103181549.20835.xavier@alternatif.org>
	<10FC03A59E498D4A90A45E4A105AD3ED02EE70F539@EXCH-MBX-2.vmware.com>
 <20110319091137.2eda1c91@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110319091137.2eda1c91@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

There are an equal number of BIOs as there are biovec-64s. But I understand why that is the case now. Turns out that some changes that were made by one of our performance engineers in the interest of increasing the performance of background resyncs when there are foreground I/Os gets in the way (or effectively neuters) the RESYNC_DEPTH throttle that exists today.

The gist of these changes is that:
 - We hold the barrier across the resync window to disallow foreground IOs from interrupting background resyncs and raise_barrier is not being invoked raid1 sync_request
 - We increase the resync window to 8M and resync chunk size to 256K

The combination of these factors caused us to have a huge number of IOs outstanding and as much as 256M of resync data pages. We are working on a fix for this. I can share a patch to MD that implements these changes if someone is interested.

Thanks again for your help!
~ Hari

-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: Friday, March 18, 2011 6:12 PM
To: Hari Subramanian
Cc: linux-raid@vger.kernel.org
Subject: Re: Adaptive throttling for RAID1 background resync

On Fri, 18 Mar 2011 13:26:52 -0700 Hari Subramanian <hari@vmware.com> wrote:

> I am hitting an issue when performing RAID1 resync from a replica hosted on a fast disk to one on a slow disk. When resync throughput is set at 20Mbps min and 200Mbps max and we have enough data to resync, I see the kernel running out of memory quickly (within a minute). From the crash dumps, I see that a whole lot (12,000+) of biovec-64s that are active on the slab cache.
> 
> Our guess is that MD is allowing data to be read from the fast disk at a frequency much higher than what the slow disk is able to write to. This continues for a long time (> 1 minute) in an unbounded fashion resulting in buildup of IOs that are waiting to be written to the disk. This eventually causes the machine to panic (we have panic on OOM selected)
> 
> >From reading the MD and RAID1 resync code, I don't see anything that would prevent something like this from happening. So, we would like to implement something to this effect that adaptively throttles the background resync.
> 
> Can someone confirm or deny these claims and also the need for a new solution. Maybe I'm missing something that already exists that would give me the adaptive throttling. We cannot make do with the static throttling (sync_speed_max and min) since that would be too difficult to get right for varying IO throughputs form the different RAID1 replicas.

The thing you are missing that already exists is 

#define RESYNC_DEPTH 32

which is a limit places on conf->barrier, where conf->barrier is incremented
before submitting a resync IO, and decremented after completing a resync IO.

So there can never be more than 32 bios per device in use for resync.


12,000 active biovec-64s sounds a lot like a memory leak - something isn't
freeing them.
Is there some 'bio-XXX' slab with a similar count.  If there isn't, then the
bio was released without releasing the biovec, which would be bad.
If there is - that information would help.

NeilBrown
