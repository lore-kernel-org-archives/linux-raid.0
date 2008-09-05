From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Date: Fri, 05 Sep 2008 15:06:22 +0200
Message-ID: <20080905130622.4C497248B8@gemini.denx.de>
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Dear Ilya &Yrui,

In message <1220478231-8725-1-git-send-email-yanok@emcraft.com> you wrote:
> 
> Should clear the next pointer of the TX if we are sure that the
> next TX (say NXT) will be submitted to the channel too. Overwise,
> we break the chain of descriptors, because we lose the information
> about the next descriptor to run. So next time, when invoke
> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
> NXT will be never submitted.
> 
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> ---
>  crypto/async_tx/async_tx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

What about this patch? SHould it be applied to our repository?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
The use of Microsoft crippleware systems is a sin that  carries  with
it its own punishment.
         -- Tom Christiansen in <6bo3fr$pj8$5@csnews.cs.colorado.edu>
