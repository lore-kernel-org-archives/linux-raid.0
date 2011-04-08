From: Yann Ormanns <yann-ormanns@web.de>
Subject: Re: RAID6 simply does not start as /dev/md8
Date: Fri, 08 Apr 2011 16:19:14 +0200
Message-ID: <4D9F1962.3050806@web.de>
References: <4D9EC097.7010600@web.de> <20110408151751.5e2b61f1@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110408151751.5e2b61f1@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Subject: Re: RAID6 simply does not start as /dev/md8
From: Roman Mamedov <rm@romanrm.ru>
To: Yann Ormanns <yann-ormanns@web.de>
Date: 2011-04-08 16:15 (+0600)

> After you do various changes to your mdadm.conf, don't forget to update your
> initrd. AFAIK mdadm.conf is copied into the compressed initrd image to be used
> early at boot, and this copy has to be kept in sync with your version in /etc.
> 
> Typically you can update initrd for all installed kernels by running something
> like:
> 
>   update-initramfs -k all -u
> 

Thank you for your quick response. I do not use an initrd - during the
boot process the kernel reconnects and assembles md1,md2,md3,md5,md6 and
md7 (these are all RAID1) without any problems. Only the assembly of the
RAID6 does not work at all.

Best regards,
Yann
