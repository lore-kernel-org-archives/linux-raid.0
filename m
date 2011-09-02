From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 to another raid level??
Date: Fri, 2 Sep 2011 20:22:35 +1000
Message-ID: <20110902202235.0194d779@notabene.brown>
References: <-7094796685559591664@unknownmsgid>
	<CAFsPQ_97jNixHoYbMfxg9=FqXPWrsz_F1ZPSu1LTdGJA7N7Zcg@mail.gmail.com>
	<20110902121959.173a1aa9@notabene.brown>
	<CAFsPQ_8dA6B9yA4ZWZgAjZggNCBbcprAZrdHeJbPv+UvRz17mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFsPQ_8dA6B9yA4ZWZgAjZggNCBbcprAZrdHeJbPv+UvRz17mA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Busby <michael.a.busby@gmail.com>
Cc: john.robinson@anonymous.org.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2 Sep 2011 10:12:32 +0100 Michael Busby <michael.a.busby@gmail.com>
wrote:

> Thanks Neil
> 
> Is there anyway back from raid0 to raid4 as i know once at raid0 i
> will no longer be able to add any disks, in theory i could change
> echo raid0 > /sys/block/md0/md/level,but this would require adding a
> missing disk to the raid4 at the same time, not sure how easy that
> would be todo
> 

Yes, you can switch from RAID0 to RAID4 in much the same way as you switch
from RAID4 to RAID0.
You can then freeze/add-disk/change-size/unfreeze/wait/switch-back-to-RAID0
to add more devices.

mdadm-3.2.2 should be able to do all this for you.  i.e. you ask it to --grow
a RAID and --add some disks at the same time, and it will do all the required
magic.

This hasn't been tested extensively, but should work in simple cases.

Of course the more devices you have in a RAID0, the less reliability you have
- but e.g. as a cache for a tape backup system a large RAID0 is fine.

NeilBrown


