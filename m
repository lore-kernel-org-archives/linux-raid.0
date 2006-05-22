From: Neil Brown <neilb@suse.de>
Subject: Re: 4 disks in raid 5: 33MB/s read performance?
Date: Tue, 23 May 2006 09:02:58 +1000
Message-ID: <17522.17186.715844.748238@cse.unsw.edu.au>
References: <200605221746.38122.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Monday May 22
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday May 22, Dexter.Filmore@gmx.de wrote:
> I just dd'ed a 700MB iso to /dev/null, dd returned 33MB/s.
> Isn't that a little slow?
> System is a sil3114 4 port sata 1 controller with 4 samsung spinpoint 250GB, 
> 8MB cache in raid 5 on a Athlon XP 2000+/512MB.
> 

Yes, read on raid5 isn't as fast as we might like at the moment.

It looks like you are getting about 11MB/s of each disk which is
probably quite a bit slower than they can manage (what is the
single-drive read speed you get dding from /dev/sda or whatever).

You could try playing with the readahead number (blockdev --setra/--getra).
I'm beginning to think that the default setting is a little low.

You could also try increasing the stripe-cache size by writing numbers
to 
   /sys/block/mdX/md/stripe_cache_size

On my test system with a 4 drive raid5 over fast SCSI drives, I
get 230MB/sec on drives that give 90MB/sec.
If I increase the stripe_cache_size from 256 to 1024, I get 260MB/sec.

I wonder if your SATA  controller is causing you grief.
Could you try
   dd if=/dev/SOMEDISK of=/dev/null bs=1024k count=1024
and then do the same again on all devices in parallel
e.g.
   dd if=/dev/SOMEDISK of=/dev/null bs=1024k count=1024 &
   dd if=/dev/SOMEOTHERDISK of=/dev/null bs=1024k count=1024 &
   ...

and see how the speeds compare.
(I get about 55MB/sec on each of 5 drives, or 270MB/sec, which
is probably hitting the SCSI buss limit which as a theoretical 
max of 320MB/sec I think)

NeilBrown

