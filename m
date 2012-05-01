From: Brian Candler <B.Candler@pobox.com>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Tue, 1 May 2012 12:15:18 +0100
Message-ID: <20120501111518.GA24265@nsrc.org>
References: <4F9AFBC6.7070803@weboperative.com>
 <20120428080355.70585026@notabene.brown> <20120501094508.GA24134@nsrc.org>
 <20120501201854.19f7def9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120501201854.19f7def9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 01, 2012 at 08:18:54PM +1000, NeilBrown wrote:
> To replicate:
> 
>  - create an array.
>  - stop the array
>  - assemble the array with at least one missing device e.g.:
>     mdadm -A /dev/md0 /dev/sda1 /dev/sdb1
>    if it was a 3-device array
>  - check in /proc/mdstat that it is listed as "inactivate"
>  - reboot
>  - now "mdadm -E" the devices.  If the raid level is -unknown- then the bug
>    has hit.

Thank you for this info.

After reboot the array came up as active again, and mdadm -E showed "Raid
Level : raid6" for all drives, so that's not the problem I had before.

Regards,

Brian.
