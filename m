From: Neil Brown <neilb@suse.de>
Subject: Re: Software RAID 6 initial sync very slow
Date: Tue, 3 Jun 2008 15:11:48 +1000
Message-ID: <18500.53908.456676.704685@notabene.brown>
References: <8CA91F18992AC9E-1724-EAF@webmail-ne13.sysops.aol.com>
	<4843E8FD.8000601@tmr.com>
	<8CA92FCA38FE330-1A8-162F@webmail-nb02.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from thomas62186218@aol.com on Monday June 2
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: davidsen@tmr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 2, thomas62186218@aol.com wrote:
> Thank you Bill and Richard for your responses.
> 
> In sync_speed_max, I had already set it to 250000 (250MB/sec). For 
> sync_speed_min, I have 249900 set. My rational behind doing this was to 
> "force" it to go as fast as it can. Any problem with this?
> 
> However, adjusting stripe_cache_size did improve performance. It was 
> 256 at first, and my sync rate was 28MB/sec. When I increased it to 
> 4096, my sync rate jumped to 38MB/sec. Then I increased it to 16384, 
> and it jumped again to 40MB/sec. Increasing stripe_cache_size above 
> that did not seem to have any effect.
> 
> My question then is, how do I set the stripe_cache_size at the time of 
> md creation? I would rather set it then, as opposed to having to echo 
> stripe_cache_size variable with a new setting. In other words, where is 
> this default value of 256 coming from? Thanks all!!

256 is the default hard coded into the kernel.
Why do you have a problem with echoing a number into the sysfs
variable.  I guess I could teach mdadm to do that for you, but it
would just open the file and write to it, just like you do.

raid6 resync (like raid5) is optimised for an array the is already in
sync.  It reads everything and checks the P and Q blocks.  When it
finds P or Q that are wrong, it calculates the correct value and goes
back to write it out.
On a fresh drive, this will involve lots of writing which means
seeking back to write something.
With a larger stripe_cache, the writes can presumably be done in
larger slabs so there are fewer seeks.

You might get a better result by creating the array with two missing
devices and two spares.  It will then read the good devices completely
linearly, and write the spares completely linearly and so should get
full hardware speed with normal stripe_cache size.

For raid5, mdadm makes this arrangement automatically.  It doesn't for
raid6.

I'd be interested to discover what speed you get if you:

  mdadm -C /dev/mdXX -l 6 -n ... -x 2  /dev/0 /dev/1 ... /dev/n-3 missing /dev/n-2 /dev/nd-1

(if you get my drift).
Of course only do this if you don't have valuable data on the array
already (though it should survive).

NeilBrown

NeilBrown
