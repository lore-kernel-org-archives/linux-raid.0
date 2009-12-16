From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Spurious HD convictions
Date: Tue, 15 Dec 2009 23:40:33 -0600
Message-ID: <8B.75.01470.8D2782B4@cdptpa-omtalb.mail.rr.com>
References: <70ed7c3e0912150047v1d3284dbk35282f8916d0ba4f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912150047v1d3284dbk35282f8916d0ba4f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> As far as I know, the numbers in between define the queue depth of
> commands sent to the disks.
> 
> It's a matter of whether you want the disk(s) firmware to manage
> sorting & executing the commands (when the queue is > 1) or not.

	Well, what I am wondering is whether or not some value higher than 1
might produce better performance without risking the error.

> all cases, as far as I know, the kernel does the sorting before
> sending the commands to the disk(s). So if you notice better
> performance (when the array is stable) with the queue=1, then keep it
> that way.

	Definitely not, it seems.  At least for the resync, turning off NCQ
dropped the read rate from 35 MBps per drive to 25 MBps per drive.

