From: Luca Berra <bluca@comedia.it>
Subject: Re: Forcing a disk online
Date: Sat, 10 Jan 2004 13:51:58 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040110125157.GC5928@percy.comedia.it>
References: <20040110004054.GB3322@munchnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040110004054.GB3322@munchnet.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 09, 2004 at 04:40:54PM -0800, Nathan Hunsperger wrote:
>However, I don't see any way to 'force a disk online' like you can on
>hardware raid.  How can I change the status?  If I can force the disk
>online, I should be able to mount the array in degraded mode, and
>recover most everything, except for the data that lies on the stripe
>using those 8K.

you have to recreate the array using all the devices in the same order
as they were before, without the spare, and using the "missing" keyword
in place of the removed drive. also other options like layout and chunk
size must be the same. having a missing drive will cause the array to be
created in degraded mode and parity not rebuilt, so you will have a
chance for data recovery

>Below is the output I have from looking at the status of each drive.
>The very last disk is the partially rebuilt replacement for Raid
>Device 7.  I need to mark RaidDevice 8 as active.
that is all the info you need.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
