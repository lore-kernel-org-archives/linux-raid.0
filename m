From: NeilBrown <neilb@suse.de>
Subject: Re: Speed up reshape? (was Re: Cancel reshape?)
Date: Wed, 12 Jan 2011 17:02:11 +1100
Message-ID: <20110112170211.3e88fdcb@notabene.brown>
References: <4D2D2BD2.7000601@anonymous.org.uk>
	<4D2D32DF.9010002@anonymous.org.uk>
	<20110112163258.699a6fe0@notabene.brown>
	<4D2D41E4.1000109@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2D41E4.1000109@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 05:53:40 +0000 John Robinson
<john.robinson@anonymous.org.uk> wrote:

> On 12/01/2011 05:32, NeilBrown wrote:
> > On Wed, 12 Jan 2011 04:49:35 +0000 John Robinson
> > <john.robinson@anonymous.org.uk>  wrote:
> [...]
> >> Perhaps I can stop the reshape and restart it with the backup file
> >> elsewhere. Hmm, I've an SSD I haven't installed yet... Maybe time to
> >> give it a wee workout :-)
> >
> > That should work.
> >
> >   mdadm --stop ...
> >   copy file
> >   mdadm --assemble ...... --backup-file=/new/place
> 
> Yup. Not much of an improvement, though; the reshape is now running at 
> ~10MB/s instead of ~6.5MB/s, so ~27 hours to go instead of ~40 hours.
> 
> iostat tells me the original 3 discs are doing ~120 transactions per 
> second, reading ~20MB/s and writing ~10MB/s, while the one new disc is 
> doing ~60 tps, reading nothing (obviously) and writing ~10MB/s and the 
> backup (SSD) is doing ~45 tps and writing ~20MB/s. ~120tps sounds about 
> right for 120 seeks, 60 reads and 60 writes, and would explain the 
> speed, but otherwise this looks odd to me - why are we reading ~60MB/s 
> in total and writing ~40MB/s? I'd have expected to be reading less than 
> we're writing. And why are we apparently reading and writing in blocks 
> of under 512KB per device, when the backup file is 32MB? Is there 
> something I can tweak to run the reshape in bigger chunks? 
> sync_speed_min is already 200000...

1/ everything is read twice, once to back it up, once to relocate it.
  That is unfortunate, but awkward to avoid.

2/ try increasing the stripe_cache_size - it might help.

NeilBrown


> 
> Currently running SystemRescueCD 2.0.0, 32-bit kernel 2.6.35 and mdadm 
> 3.1.4. CPU usage is 2% system, 4% iowait.
> 
> Cheers,
> 
> John.

