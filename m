From: Luca Berra <bluca@comedia.it>
Subject: Re: raid5+ lvm2 disaster
Date: Fri, 16 Jul 2004 15:27:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040716132712.GB18585@percy.comedia.it>
References: <40EEFD38.8080805@dobbels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40EEFD38.8080805@dobbels.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 09, 2004 at 10:16:56PM +0200, Bernhard Dobbels wrote:
>Hi,
>
>Short history: configured raid5 + lvm2 for data disks. Everything worked 
>fine. When converting root (system disk) to raid 1, I've lost my system 
>disks. I did a reinstall (1st time in 4 years) of Debian and compiled a 
>new kernel 2.6.6.
>
>Now trying to recover my raid 5 + lvm. When raid 5 was up (in degraded 
>mode), I could see all my lv's, so I think all data is still ok.
>
>I had problems with DMA timeout and with the patch mentioned in 
>http://kerneltrap.org/node/view/3040 for pDC20268, which had the same 
>erors in messages.
>I've checked the raid with lsraid and two disks seemed ok, although, one 
>was mentioned as spare.
>I did a mkraid --really-force /dev/md0 to remake the raid, but after 
>this, I cannot start it anymore.

junk **raid and use mdadm.

anyway you don't tell us which fstab you used for doing the mkraid, and
how it related to the current status of your drives.

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
