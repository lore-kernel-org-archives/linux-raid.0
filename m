From: Neil Brown <neilb@suse.de>
Subject: Re: [patch 3/4] fastboot: make the raid autodetect code wait for
	all devices to init
Date: Tue, 22 Jul 2008 09:24:36 +1000
Message-ID: <18565.6836.784228.255912@notabene.brown>
References: <20080720151140.4aa7c682@infradead.org>
	<20080720151339.6f4a83d8@infradead.org>
	<18563.50428.659101.868745@notabene.brown>
	<20080721113417.GA8152@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from martin f krafft on Monday July 21
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday July 21, madduck@madduck.net wrote:
> also sprach Neil Brown <neilb@suse.de> [2008.07.21.0106 +0200]:
> > The "real" solution here involves assembling arrays in userspace using
> > "mdadm --incremental" from udevd, and using write-intent-bitmaps so
> > that writing to an array before all the component devices are
> > available can be done without requiring a full resync.  There is still
> > a bit more code needed to make that work really smoothly.
> 
> It was my understanding that write-intent bitmaps slow down all
> operations and are not suggested on e.g. workstations. No?

Well, they don't slow down reads.
If you have a separate root filesystem (i.e. /home and /var are
elsewhere), it is likely to be read-mostly, so bitmaps probably won't
hurt much.
And an external bitmap on a dedicated device has minimal performance
cost.

However I neither suggest having nor not-having bitmaps.  The choice to
use them involves a trade-off which I cannot make for other people.

They would, however, be very useful to cover the gap when assembling
arrays incrementally.
If, for example, you have a 6 disk raid5 array and 5 disks have been
found, what do you do?  
  - wait for the 6th, that might never arrive
  - start degraded and if a write happens before the 6th disk arrives,
    have to rebuild the 6th disk completely.

Neither is a good option.
An alternate is
  - add an internal bitmap, and remove it after the 6th disk has
    arrived, or after we are sure there are no more disks to find.

Doing this means that if a recovery is needed when the 6th disk
arrives, it will be very fast.

It's not hard to notice that the bitmap proposed here does not need to
be on stable storage.  It is not protecting against a crash, just
against a window when the array is degraded.  So if we could support
bitmaps on a tmpfs, we could use an external bitmap in /tmp instead of
an internal bitmap.
Or even - we could enhance the md code to always use a bitmap, but
simply not write it to storage if no such was configured.

(If a crash happens during that window between writing to the degraded
array and recovering the few blocks needed on the final device, then
you would be in an unfortunate position.  For raid1/10 you would just
need a full resync, which you would have needed anyway, so no loss.
For raid4/5/6, you have a potential for dataloss, so I probably would
not make this behaviour the default for those levels...)

NeilBrown
