From: Luca Berra <bluca@comedia.it>
Subject: Re: Best Practice for Raid1 Root
Date: Thu, 15 Jan 2004 13:48:09 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040115124809.GE3703@percy.comedia.it>
References: <NMEHJKFGFEGJPIPOLFFECEMHDEAA.valo@valo.at> <4005DF8C.7080206@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4005DF8C.7080206@tls.msk.ru>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 15, 2004 at 03:32:12AM +0300, Michael Tokarev wrote:
>When using raid-extra-boot, lilo treats second disk as bios #0x81,
>3rd disk as bios #0x82 and so on.  That to say - if your first disk
>fails and BIOS will substitute second disk in place of first, making
>it 0x80 instead of 0x81, lilo will not boot too, exactly in a way
>why grub installed into /dev/hdb (that was e.g. temporarily plugged
>into another machine just to make it bootable etc) does not want to
>boot from it when it will be /dev/hda again (when returned back into
>it's own machine).
this is not true

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
