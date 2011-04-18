From: NeilBrown <neilb@suse.de>
Subject: Re: Resync intermittently writes to spare drives, waking them up
Date: Mon, 18 Apr 2011 10:55:18 +1000
Message-ID: <20110418105518.2ef04e47@notabene.brown>
References: <BANLkTikqAaS91n06Xw7SwWcMKik_8E0iHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikqAaS91n06Xw7SwWcMKik_8E0iHA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rory Jaffe <rsjaffe@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 13 Apr 2011 14:10:46 -0700 Rory Jaffe <rsjaffe@gmail.com> wrote:

> I have a RAID5 array with 4 active devices and two spares. The spares
> are normally in sleep mode. I ran a resync with:
> 
> echo repair > /sys/devices/virtual/block/md0/md/sync_action
> 
> About 20 times (evenly spaced apart) during the resync, the spares
> were written to, waking them up. Is that behavior desired? It seems to
> me that it's a waste--I don't know why the resync would bother with
> the spares.

Yes, there is room for optimisation there.  It really shouldn't write to
those devices.  I guess I should try (again) to fix that.

Thanks for the report.

NeilBrown
