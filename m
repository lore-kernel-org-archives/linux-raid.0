From: Reuben Farrelly <reuben-lkml@reub.net>
Subject: Re: [PATCH 000 of 3] md: Introduction - 3 bugfixs for -mm
Date: Thu, 18 May 2006 00:04:40 +1200
Message-ID: <446B1158.8030608@reub.net>
References: <20060516111036.2649.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060516111036.2649.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
List-Id: linux-raid.ids

On 16/05/2006 1:12 p.m., NeilBrown wrote:
> The first of these fixes issues with the new bmap based bitmap file
> access code, and possibly should be an -mm hotfix, and without it,
> 'internal' bitmaps don't work any more :-(
> 
> Others are minor and unrelated.
> 
> Thanks,
> NeilBrown
> 
> 
>  [PATCH 001 of 3] md: Change md/bitmap file handling to use bmap to file blocks-fix
>  [PATCH 002 of 3] md: Fix inverted test for 'repair' directive.
>  [PATCH 003 of 3] md: Calculate correct array size for raid10 in new offset mode.

Patch 1 fixes the problems I was having with RAID-1 arrays not able to start up 
on 2.6.17-rc4-mm1.  Thanks for that.

However things appear still not quite right on boot, as each mount works but 
displays as though it didn't work, ie:

md: considering sdc2 ...
md:  adding sdc2 ...
md:  adding sda2 ...
md: created md0
md: bind<sda2>
md: bind<sdc2>
md: running: <sdc2><sda2>
raid1: raid set md0 active with 0 out of 2 mirrors

0 out of 2 ?

cat /proc/mdstats  shows that everything does in fact seem to be working:

md0 : active raid1 sdc2[1] sda2[0]
       24410688 blocks [2/2] [UU]
       bitmap: 21/187 pages [84KB], 64KB chunk

The array otherwise seems to be fine.  I guess it's just a visual glitch.

reuben
