From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Raid 1 disk scheduling
Date: Mon, 30 May 2005 10:01:58 +0200
Message-ID: <62b0912f05053001013e2d8e47@mail.gmail.com>
References: <20050529190628.46785.qmail@web30501.mail.mud.yahoo.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050529190628.46785.qmail@web30501.mail.mud.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dbakker1@yahoo.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David F. Bakker wrote:
> I have a server with lots of available RAM (10GB) I
> wanted to create an md raid 1 device that would mirror
> a large ramdisk (2GB) to a scsi md device. The
> thinking here is writes will be just as fast as always
> since I/O is sync to both the RAM and hard disk.
> However reads should be crazy fast since it should be
> coming from the device with the lower latency or the
> one that answers first (RAM). It looks like the I/O is
> done in a round robin setup. I get amazing reads every
> other test (cat'n a file) which seems it is a round
> robin scheme. Can this be changed somehow to prefer a
> device or use latency instead?

Linux should use any available RAM for disk cache.
Are you sure that using MD as a disk cache like above is any faster than that?
