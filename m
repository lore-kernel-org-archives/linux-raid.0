From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: modifying degraded raid 1 then re-adding other members is bad
Date: Wed, 9 Aug 2006 08:35:38 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0608090834060.11585@yvahk01.tjqt.qr>
References: <or8xlztvn8.fsf@redhat.com> <17624.29070.246605.213021@cse.unsw.edu.au>
 <44D8732C.2060207@tls.msk.ru> <17625.4242.910985.97868@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17625.4242.910985.97868@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Alexandre Oliva <aoliva@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

>> Why we're updating it BACKWARD in the first place?
>
>To avoid writing to spares when it isn't needed - some people want
>their spare drives to go to sleep.

That sounds a little dangerous. What if it decrements below 0?


Jan Engelhardt
-- 
