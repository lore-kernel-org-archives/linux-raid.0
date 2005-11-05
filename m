From: Neil Brown <neilb@suse.de>
Subject: Re: [fwd: ECC circuitry error / md weirdness?]
Date: Sat, 5 Nov 2005 16:45:29 +1100
Message-ID: <17260.18169.499138.282611@cse.unsw.edu.au>
References: <20051105012019.GF19967@eriador.mirkwood.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from PinkFreud on Friday November 4
Sender: linux-raid-owner@vger.kernel.org
To: PinkFreud <pf-raid20051104@mirkwood.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 4, pf-raid20051104@mirkwood.net wrote:
> I'm resending to this list.  Any ideas why md was happily writing to a
> disk that the kernel thought had problems?

It appears that the ide driver didn't tell the md driver that it had
problems.

> 
> Oct 27 23:44:58 cbs-server kernel: hdk: status timeout: status=0x80 {
> Busy }
> Oct 27 23:44:58 cbs-server kernel: 
> Oct 27 23:44:58 cbs-server kernel: hdk: DMA disabled
> Oct 27 23:44:58 cbs-server kernel: PDC202XX: Secondary channel reset.
> Oct 27 23:44:58 cbs-server kernel: hdk: drive not ready for command
> Oct 27 23:45:04 cbs-server kernel: ide5: reset: master: ECC circuitry
> error
> Oct 27 23:45:04 cbs-server kernel: hdk: status error: status=0x58 {
> DriveReady SeekComplete DataRequest }

If md got a failure back from an IO request, it should say:

 raid5: Disk failure on kdj, disabling device. ....

The fact that it didn't strongly suggests and error never came
back....

Maybe the PDC202XX driver was retrying lots of times or something.

Sorry I cannot be more helpful.

NeilBrown
