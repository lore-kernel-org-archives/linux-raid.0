From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Software RAID 6 initial sync very slow
Date: Mon, 02 Jun 2008 08:37:46 +1200
Message-ID: <4843089A.7040909@sauce.co.nz>
References: <8CA91F18992AC9E-1724-EAF@webmail-ne13.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CA91F18992AC9E-1724-EAF@webmail-ne13.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thomas62186218@aol.com wrote:

> My first test was to create a RAID 6 md device, 128K chunk, with all 12 
> drives. The sync is currently underway at a very slow 30MB/sec, with 
> mdadm estimating this as a 9hr process. With an Adaptec 5805 RAID card 
> tested, I performed the RAID 6 initial sync with the same 12 drives in 
> just under 5 hours. Meanwhile, our total CPU usage during mdadm syncing 
> is at 5%, so there's plenty of CPU not being used.

I have a very similar system, except single quad core and 16 x 750GB

It syncs (md RAID6) in 3:40min which is roughly proportional to the time 
you see with your hardware RAID sync up, so you should be able to match 
it with md RAID.

I cannot remember whether stripe_cache_size affected the sync time - 
currently I have this set to 16384.

Regards,

Richard
