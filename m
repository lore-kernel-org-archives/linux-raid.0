From: NeilBrown <neilb@suse.de>
Subject: Re: Adaptive throttling for RAID1 background resync
Date: Sat, 19 Mar 2011 09:11:37 +1100
Message-ID: <20110319091137.2eda1c91@notabene.brown>
References: <201103181549.20835.xavier@alternatif.org>
	<10FC03A59E498D4A90A45E4A105AD3ED02EE70F539@EXCH-MBX-2.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10FC03A59E498D4A90A45E4A105AD3ED02EE70F539@EXCH-MBX-2.vmware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hari Subramanian <hari@vmware.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

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
