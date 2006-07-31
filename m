From: Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH 005 of 9] md: Replace magic numbers in sb_dirty with well defined bit flags
Date: Mon, 31 Jul 2006 17:33:11 +0200
Message-ID: <200607311733.12848.ioe-lkml@rameria.de>
References: <20060731172842.24323.patches@notabene> <1060731073218.24482@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060731073218.24482@suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I think the names in this patch don't match the description at all.
May I suggest different ones?

On Monday, 31. July 2006 09:32, NeilBrown wrote:
> 
> Instead of magic numbers (0,1,2,3) in sb_dirty, we have
> some flags instead:
> MD_CHANGE_DEVS
>    Some device state has changed requiring superblock update
>    on all devices.

MD_SB_STALE or MD_SB_NEED_UPDATE

> MD_CHANGE_CLEAN
>    The array has transitions from 'clean' to 'dirty' or back,
>    requiring a superblock update on active devices, but possibly
>    not on spares

Maybe split this into MD_SB_DIRTY and MD_SB_CLEAN ?

> MD_CHANGE_PENDING
>    A superblock update is underway.  

MD_SB_PENDING_UPDATE


Regards

Ingo Oeser
