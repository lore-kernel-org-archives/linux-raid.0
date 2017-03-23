From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] raid5-ppl: silence a misleading warning message
Date: Thu, 23 Mar 2017 13:00:40 +0100
Message-ID: <20da4597-fc61-f1cd-f8f5-85355e8cec5c@intel.com>
References: <20170321204305.GC22118@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170321204305.GC22118@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On 03/21/2017 09:43 PM, Dan Carpenter wrote:
> The "need_cache_flush" variable is never set to false.  When the
> variable is true that means we print a warning message at the end of
> the function.
> 
> Fixes: 3418d036c81d ("raid5-ppl: Partial Parity Log write logging implementation")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Good catch, thanks. I thought gcc would warn about such issues, I'll
have to be more careful.

Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
