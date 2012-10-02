From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID6 rebuild stuck
Date: Mon, 1 Oct 2012 19:50:12 -0600
Message-ID: <2BB1B524-60C9-4B79-96C8-A50FDFEBFB49@colorremedies.com>
References: <20121001112946.GB27455@nsrc.org>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121001112946.GB27455@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 1, 2012, at 5:29 AM, Brian Candler wrote:

> So mdstat says that recovery is ongoing, when clearly it isn't. I'm not sure
> what I should do next.  Should I just hot-swap sdg, or should I reboot to
> clear the stuck /proc/mdstat status?

It might be superfluous, but looks like you should be able to to stop the resync/repair by using:

echo idle  > md/sync_action

In any case you need to fail the drive, if it hasn't already been rejected again, and remove the drive from the array.

mdadm /dev/md1 --fail /dev/sdg
mdadm /dev/md1 --remove /dev/sdg

Replace the drive - i.e. physically remove the bad one, and replace it with a good one. You'll need to find out what its designation is to add it:

mdadm /dev/md1 --add /dev/sdX

You should start getting a resync right away.

Chris Murphy

