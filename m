From: Luca Berra <bluca@comedia.it>
Subject: Re: 3ware 7500-8 confusion
Date: Sun, 23 Feb 2003 10:36:49 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030223093648.GA4223@percy.comedia.it>
References: <Pine.LNX.3.96.1030222210002.29904A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.96.1030222210002.29904A-100000@Maggie.Linux-Consulting.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 22, 2003 at 09:08:04PM -0800, Alvin Oga wrote:
>3dm was installed from the cdrom that came w/ the controller
>
you may want to look in tw_cli (3ware commandline client)
you can download it from 3ware site
3dm sucks

>but now that i wanna use the hw raid, and want to do:
>	fdisk /dev/md0
>	mke2fsc -j -m 1 /dev/md0
>	mount /dev/md0 /Raid
>
>but there is no such thing as /dev/md0 ... *pout*
>
>what is the name of the device ( /dev/xxx ) that 3ware built ??
>	- went digging/googling around but didnt find my answer yet

3ware is seen as a scsi controller
/dev/sd*
cat /proc/partitions helps a lot

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
