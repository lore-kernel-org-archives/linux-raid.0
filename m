From: Luca Berra <bluca@comedia.it>
Subject: Re: MD Warnings on RAID5 linux 2.4.22
Date: Sun, 28 Mar 2004 12:17:52 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040328101751.GB18066@percy.comedia.it>
References: <20040326232438.98003.qmail@web14526.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040326232438.98003.qmail@web14526.mail.yahoo.com>
To: Don Jessup <donj@asaca.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 26, 2004 at 03:24:38PM -0800, Don Jessup wrote:
>Apr  5 15:19:57 DM200_791498 kernel: md14: WARNING: [dev e7:a4] appears to be
>on the same physical disk as [dev
>e7:a0]. True
....
>   The command I'm using to assemble the RAID looks like the following:
>      mdadm --assemble /dev/md14
>--uuid=c9cc5194:50e0de0d:af3b7236:a60790c9
>--update=super-minor /dev/mapd145:1 /dev/mapd149:1 /dev/mapd153:1
>/dev/mapd157:1 /dev/mapd161:1 /dev/mapd165:1
>
>

It seems that the kernel does not have any knowledge that device type 7e
should be handled differently.
the disk driver should define a correct minor_shift which will allow md
to know if two devices are on the same physical disk or not.

fix your disk device driver. or at least tell us which kind of hw it is.

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
