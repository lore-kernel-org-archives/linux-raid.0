From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: compile errors in 2.6.8.1 in drivers/md/*
Date: Fri, 27 Aug 2004 06:39:47 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408270639.47900.kevcorry@us.ibm.com>
References: <20040827093634.GA4853@fuchi>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040827093634.GA4853@fuchi>
Content-Disposition: inline
To: Sebastian Henschel <shensche@xtops.de>, linux-raid@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: linux-raid.ids

On Friday 27 August 2004 04:36, Sebastian Henschel wrote:
> hello folks...
>
> hopefully i am right here... i just compiled a kernel 2.6.8.1 and two
> similar errors occurred:
>
> drivers/md/dm-raid.c:1241 - the workqueue creation misses an argument. i
> have set the flag to 0.
> drivers/md/kcopyd.c:612 - the singlethread workqueue creation misses an
> argument. i have set the flag to 0.
>
> the kernel compiles now, but i do not if it really is a fix. since the
> machine this kernel was compiled on, does not make use of a software
> raid, i cannot test it.

Are you building a stock 2.6.8.1 kernel? Could it be -mm or one of the other 
common extra patchsets? I don't see any compile warnings or errors anywhere 
in the drivers/md/ directory when I build my kernel, which is mostly a stock 
2.6.8.1 with a few extra DM patches. 

-- 
Kevin Corry
kevcorry@us.ibm.com
http://evms.sourceforge.net

