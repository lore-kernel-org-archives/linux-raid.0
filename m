From: Derek Vadala <derek@cynicism.com>
Subject: Re: Adding spare drive
Date: Mon, 6 May 2002 21:29:51 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0205062122580.15444-100000@gecko.roadtoad.net>
References: <002901c1f579$464ec5a0$050010ac@niunia.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002901c1f579$464ec5a0$050010ac@niunia.org>
To: linux-raid@vger.kernel.org
Cc: "mousebusiness.com" <arturj@mousebusiness.com>
List-Id: linux-raid.ids

On Mon, 6 May 2002, mousebusiness.com wrote:

> I will be building a RAID5 array with 5 data drives and one hot spare. I
> need to use the drive for hot spare for something else at the moment. Is it
> possible to build my array with 5 drives and add hot spare later by simply
> adding the entry for it in /etc/raidtab?

Just create a 5-disk RAID-5 without a hot spare. When you're ready to
bring the spare disk into the array just use raidhotadd to insert it.

# raidhotadd /dev/md0 /dev/<sparedevice>

Now <sparedevice> is a spare disk in /dev/md0 (the 5-disk RAID-5). Now
update /etc/raidtab to reflect the new config. That means you'll add
nr-spare-disks and a device/spare-disk entry for /dev/<sparedevice>.

You can raidstop and raidstart the array to make sure it works, if it
makes you feel better, but you shouldn't need to.

> The array will be built with 6 drives connected to 3 IDE controllers, one
> per channel, 2 channels on each board. If one controller fails, obviously
> the array will go down with it. Does that mean that all data will be
> irrecoverably lost or will things go back to normal after I replace
> defective controller and let the array resync?

You'll be able to recover from a controller failure by replacing the
failed controller. Since physical controller placement typically impacts
device names you want to make sure you put a new controller in the same
slot as the one the failed, or make sure you have mapped out the disk
order and changed /etc/raidtab to reflect any changes.

---
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

