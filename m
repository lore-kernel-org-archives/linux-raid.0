From: thunder7@xs4all.nl
Subject: Re: 2.6.21-mm2 boot failure, raid autodetect, bd_set_size+0xb/0x80
Date: Fri, 11 May 2007 20:53:08 +0200
Message-ID: <20070511185308.GA3845@amd64.of.nowhere>
References: <20070509012322.199f292b.akpm@linux-foundation.org> <20070511180334.GA4068@amd64.of.nowhere> <20070511111809.bec8b938.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070511111809.bec8b938.akpm@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: thunder7@xs4all.nl, linux-kernel@vger.kernel.org, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, May 11, 2007 at 11:18:09AM -0700
> 
> Yes, Neil had a whoops and a dud patch spent a day in mainline.
> 
> Hopefully the below revert (from mainline) will fix it.
> 
> 
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=44ce6294d07555c3d313757105fd44b78208407f
> Commit:     44ce6294d07555c3d313757105fd44b78208407f
> Parent:     497f050c42e46a4b1f6a9bcd8827fa5d97fe1feb
> Author:     Linus Torvalds <torvalds@woody.linux-foundation.org>
> AuthorDate: Wed May 9 18:51:36 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Wed May 9 18:51:36 2007 -0700
> 
>     Revert "md: improve partition detection in md array"
>     


I can boot after applying this patch.

Thanks,
Jurriaan
-- 
"T'lan Imass were never nothing but trouble," he said. "Always two sides
to whatever they did, maybe more than two. Maybe hundreds."
	Steven Erikson - Deadhouse Gates
Debian (Unstable) GNU/Linux 2.6.21-mm2 2x2010 bogomips load 0.42
the Jack Vance Integral Edition: http://www.integralarchive.org
