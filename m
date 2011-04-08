From: Yann Ormanns <yann-ormanns@web.de>
Subject: Re: RAID6 simply does not start as /dev/md8
Date: Fri, 08 Apr 2011 20:23:26 +0200
Message-ID: <4D9F529E.20204@web.de>
References: <4D9EC097.7010600@web.de> <20110408151751.5e2b61f1@natsu> <4D9F1962.3050806@web.de> <4D9F1A5A.1060600@grumpydevil.homelinux.org> <4D9F22A9.1030005@web.de> <4D9F2819.2030403@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D9F2819.2030403@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Subject: Re: RAID6 simply does not start as /dev/md8
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
To: Yann Ormanns <yann-ormanns@web.de>
Date: 2011-04-08 20:22 (+0200)

> Just to humour me, the output without the partition number? so /dev/sda ?
> 
> Cheers,
> 
> 
> Rudy
> 

Output of "mdadm -E /dev/sd[a,b,c,d,e,f]":
mdadm: No md superblock detected on /dev/sda.
mdadm: No md superblock detected on /dev/sdb.
mdadm: No md superblock detected on /dev/sdc.
mdadm: No md superblock detected on /dev/sdd.
mdadm: No md superblock detected on /dev/sde.
mdadm: No md superblock detected on /dev/sdf.

Best regards,
Yann
