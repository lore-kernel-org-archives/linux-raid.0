From: Luca Berra <bluca@comedia.it>
Subject: Re: changing MD device
Date: Wed, 14 Jan 2004 23:02:00 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040114220159.GM26406@percy.comedia.it>
References: <4005B847.5090306@netscape.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4005B847.5090306@netscape.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 14, 2004 at 04:44:39PM -0500, Aaron Gee wrote:
>I have a system up and running, the root directory is mounted on device 
>/dev/md0 which is a raid1 of 2 IDE drives.  My question is, how can I 
>change it so that the my raid device is /dev/md1 not /dev/md0 and not 
>loose the data.  Originally I was thinking of booting with a rescue 
>disk, breaking the raid1, and rebooting.  Once rebooted create the raid 
>device again as /dev/md1.  Is there a simpler way to do this? 
if your rescue disk contains mdadm you can use the
mdadm -A -U super-minor /dev/md1 /dev/hd?? once and the array will be
started and the minor updated

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
