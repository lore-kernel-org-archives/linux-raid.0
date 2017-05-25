From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Reducing the number of devices in a degraded RAID-5
Date: Thu, 25 May 2017 09:24:36 +0200
Message-ID: <20170525072436.GA24881@metamorpher.de>
References: <20170522125332.GA18406@metamorpher.de>
 <87h90bhujz.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87h90bhujz.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 24, 2017 at 12:12:32PM +1000, NeilBrown wrote:
> What does work is:
>  # start with a degraded array, device 0 missing
>  mdadm --grow /dev/md42 --array-size=.....
>  echo frozen > /sys/block/md42/md/sync_action
>  mdadm /dev/md42 --add /dev/loop0
>  echo 0 > /sys/block/md42/md/dev-loop0/slot
>  mdadm --grow /dev/md42 --backup-file=... --raid-devices=4

Wow. Thanks.

This should merge Step 1+2, but not Step 3, right?

I really need to take a closer look at the things in /sys/.../md/...

Seems like you can do great things with it... terrible, yes, but great.

(
  Step 3 would be turning slot 4 to-be-spare into slot 0, 
  without --add ing another device at all.

  That's what would happen if /dev/loop0 was actually backed 
  by and thus identical with the slot4 device.

  But that's playing dirty.
)

Regards
Andreas Klauer
