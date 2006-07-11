From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Kernel 2.6.17 and RAID5 Grow Problem (critical section backup)
Date: Tue, 11 Jul 2006 09:52:00 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0607110950450.30961@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0607070830450.2648@p34.internal.lan>
 <Pine.LNX.4.64.0607070845280.2648@p34.internal.lan>
 <Pine.LNX.4.64.0607070849140.3010@p34.internal.lan>
 <Pine.LNX.4.64.0607071037190.5153@p34.internal.lan> <17582.55703.209583.446356@cse.unsw.edu.au>
 <Pine.LNX.4.64.0607101747160.2603@p34.internal.lan>
 <Pine.LNX.4.61.0607110026030.5420@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0607101830130.2603@p34.internal.lan>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1283855629-366268452-1152604320=:30961"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0607101830130.2603@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1283855629-366268452-1152604320=:30961
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

>> Hm, what's superblock 0.91? It is not mentioned in mdadm.8.
>> 
>
> Not sure, the block version perhaps?
>
Well yes of course, but what characteristics? The manual only lists

 0, 0.90, default
        Use the original 0.90  format  superblock.   This  format
        limits  arrays to 28 componenet devices and limits compo■
        nent devices of levels 1 and greater to 2 terabytes.

 1, 1.0, 1.1, 1.2
        Use the new version-1 format superblock.   This  has  few
        restrictions.    The   different   subversion  store  the
        superblock at different locations on the  device,  either
        at  the  end (for 1.0), at the start (for 1.1) or 4K from
        the start (for 1.2).

No 0.91 :(
(My mdadm is 2.2, but the problem remains in 2.5.2)


Jan Engelhardt
-- 
--1283855629-366268452-1152604320=:30961--
