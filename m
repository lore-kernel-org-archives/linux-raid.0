From: Luca Berra <bluca@comedia.it>
Subject: Re: Can't boot from /dev/md0 (RAID-1)
Date: Sun, 30 Jun 2002 18:22:25 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020630162225.GB2335@colombina.comedia.it>
References: <200206301537.44139.roy@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200206301537.44139.roy@karlsbakk.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 30, 2002 at 03:37:44PM +0200, Roy Sigurd Karlsbakk wrote:
> I hope this is not OT - didn't find any LILO mailing list. after trying 
> virtually everything - can anyone help me with a tip?
> 
> 
> Running 2.4.19-pre10-ac2, RedHat 7.3 (LILO version 21.4-4), I have root on 
> /dev/md0 on RAID-1 on /dev/hda1 and /dev/hdb1. I've tried the howto at 
> http://www.tldp.org/HOWTO/mini/Boot+Root+Raid+LILO-3.html#ss3.1, but it still 
please someone update that blasted howto, lilo has been supporting boot from md
for ages.

use:
boot=/dev/md0
map=/boot/map
install=/boot/boot.b

image=/boot/bzImage
    root=/dev/md0
    read-only
    label=LinuxRaid

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
