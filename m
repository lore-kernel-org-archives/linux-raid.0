From: Massimiliano Masserelli <negro@interim.it>
Subject: Re: your mail
Date: Wed, 30 Oct 2002 10:59:54 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021030095954.GR1472@sgabanaz.interim.it>
References: <Pine.LNX.4.33.0210291720140.7119-100000@pandora.is.bizsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0210291720140.7119-100000@pandora.is.bizsystems.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 29, 2002 at 05:26:23PM -0800, Michael Robinton wrote:

> There is no standard for the behavior of the motherboard bios when the
> first device 0x80 is not available at boot time. Some motherboards
> will automove 0x81 -> 0x80, some can do it as a bios change, some
> you're stuck.

Yes, I know. Anyway the problem doesn't seem connected with LILO, since
the kernel uncompresses smoothly, loads up the initrd image and THEN
hangs. The point is that the raidstart seems unable to initialize the
array if the /dev/hda disk is not present, and I can't understand why.
Is there some sort of priority between disks in a RAID-1 array?

Bye.
-- 
Massimiliano Masserelli
-------------------------------------------------------------------------------
He who hesitates is sometimes saved.
