From: Juri Haberland <list-linux.raid@spoiled.org>
Subject: Re: MD drivers problems on 2.4.x
Date: Mon, 26 May 2003 00:24:44 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <news2mail-barmsb$tl4$1@cartman.spoiled.org>
References: <200305231535.17808.ebenard@free.fr>
Reply-To: Juri Haberland <juri@koschikode.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eric BENARD / Free <ebenard@free.fr> wrote:
> Hi,
> 
> I would like to know what is the md driver status on 2.4.19 and 2.4.20 kernels 
> ?
> I ve got many problems with RAID 0 (/tmp), 1 (/, /usr/var) and 5 (/home) using 
> these kernels and 4 IDE drives with ext3 partitions. In the end each time I 
> lose all the data :-( 
> After many tests (RAM is OK, HD don't have badblocks), I think the problems 
> comes from the md layer.
> 
> May a switch to 2.4.21-rc3 solve my problems ?
> 
> Did anyone here already meet this problem ?
> 
> Many thanks and best regards

Sorry, no problems here. /, /home, swap and the other stuff all on RAID1
and humming along.
We need more data from you. What is failing in which way? Any error
messages, kernel oopses?

Cheers,
Juri

-- 
Juri Haberland  <juri@koschikode.com> 

