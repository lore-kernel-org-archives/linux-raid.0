From: Guy Martin <gmsoft@tuxicoman.be>
Subject: Re: Raid 5 to raid 6 reshape failure after reboot
Date: Thu, 22 Oct 2009 16:20:29 +0200
Message-ID: <20091022162029.0cc2a1aa@zombie>
References: <20091018181033.0255346c@borg.bxl.tuxicoman.be>
	<358606dfd356518f7fa42219f26082d2.squirrel@neil.brown.name>
	<20091019155322.65b4287f@zombie>
	<5744c797713398f21b00e5323ddeac1e.squirrel@neil.brown.name>
	<c57ee40d9e6139de2993fb18934837c2.squirrel@neil.brown.name>
	<20091020103731.5dc611ff@zombie>
	<19167.40181.250468.925659@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19167.40181.250468.925659@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil,

While redoing the reboot test, I've also noticed this :
When I first issue the --grow command, I see the following in dmesg :
[192752.106467] md: reshape of RAID array md0
[192752.106473] md: minimum _guaranteed_  speed: 200000 KB/sec/disk.
[192752.106479] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.

The minimum guaranteed speed should be 1000KB/sec according to the
entry in /proc/sys/dev/raid/speed_limit_min.

Also, the performances are not really good. I have about 400K/sec according to /proc/mdstat.

Now, if I stop the array and assemble it again, things are better. The output in dmesg displays the correct value :
[193138.646204] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[193138.646210] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.

And perf are much better, I now get ~1500K/s which shrinks the time of the reshape from ~2 weeks to 'only' a few days.

Any thoughts ?

HTH,
  Guy


On Thu, 22 Oct 2009 10:44:53 +1100
Neil Brown <neilb@suse.de> wrote:


> Thanks for helping make mdadm even better!
> 
> NeilBrown
> 
