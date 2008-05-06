From: Luca Berra <bluca@comedia.it>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Tue, 6 May 2008 08:36:10 +0200
Message-ID: <20080506063609.GA3412@percy.comedia.it>
References: <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us> <47E43E57.5010409@tmr.com> <20080321235557.GA11801@cthulhu.home.robinhill.me.uk> <47E4D95A.9000505@rabbit.us> <481D65FA.4090107@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <481D65FA.4090107@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 04, 2008 at 09:30:02AM +0200, Peter Rabbitson wrote:
>I want to resurect this discussion with a peculiar observation - the above 
>mismatch was caused by GRUB.
...
>I realized that my grub config contains a savedefault clause, which updates 
>the file on the raw ext3 volume before any raid assembly has taken place. 
>Executing grub-set-default from within a booted system (with a mounted 
>assembled raid) resulted in the subsequent md check to return 0 mismatches. 
this has been a long standing issue with grub 1.x
hopefully some day grub 2 will be production ready and the issue will be
forgoten (real md raid support for grub 2 was added in google SOC 2006).

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
