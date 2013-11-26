From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: ARC-1120 and MD very sloooow
Date: Mon, 25 Nov 2013 21:58:21 -0600
Message-ID: <52941C5D.1000305@hardwarefreak.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com> <20131126025210.GL8803@dastard>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131126025210.GL8803@dastard>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jimmy Thrasibule <thrasibule.jimmy@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On 11/25/2013 8:52 PM, Dave Chinner wrote:
...
> sunit/swidth is in filesystem blocks, not sectors. Hence
> sunit is 1MB, swidth = 2MB. While it's not quite correct
> (su=512k,sw=1m), it's not actually a problem...

Well that's what I thought as well, and I was puzzled by the 8 blocks
value for the log sunit.  So I double checked before posting, and 'man
mkfs.xfs' told me

	sunit=value
              This is used to specify the stripe unit for a RAID device
              or a logical volume. The  value  has  to  be specified in
              512-byte block units.

So apparently the units of 'sunit' are different depending on which XFS
tool one is using.  That's a bit confusing.  And 'man xfs_info'
(xfs_growfs) doesn't tell us that sunit is given in filesystem blocks.
I'm using xfsprogs 3.1.4 so maybe these have been corrected since.

> Well, mkfs.xfs just uses what it gets from the kernel, so it
> might have been told the wrong thing by MD itself.  However, you can
> modify sunit/swidth by mount options, so you can't directly trust
> what is reported from xfs_info to be what mkfs actually set
> originally.

Got it.

> Again, lsunit is in filesystem blocks, so it is 32k, not 4k. And
> yes, the default lsunit when the sunit > 256k is 32k. So, nothing
> wrong there, either.

So where should I have looked to confirm sunit reported by xfs_info is
in fs block (4KB) multiples, not the in the 512B multiples of mkfs.xfs?

> The usual: "iostat -x -d -m 5" output while the test is running.
> Also, you are using buffered IO, so changing it to use direct IO
> will tell us exactly what the disks are doing when Io is issued.
> blktrace is your friend here....

It'll be interesting to see where this troubleshooting leads.  Buffered
single stream write speed is ~6x slower than read w/RAID10.  That makes
me wonder if the controller and drive write caches have been disabled.
That could explain this.

-- 
Stan
