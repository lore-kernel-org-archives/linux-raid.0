From: Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Date: Fri, 05 Sep 2008 14:17:22 +0400
Message-ID: <48C10732.1050009@emcraft.com>
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com>	 <20080904141945.f5c4c3eb.akpm@linux-foundation.org>	 <e9c3a7c20809041624o24af57fsbe58507a44e6e2ef@mail.gmail.com> <e9c3a7c20809041703h5bf6a007g6dcbe8fb2a5deffd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20809041703h5bf6a007g6dcbe8fb2a5deffd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, wd@denx.de, yur@emcraft.com
List-Id: linux-raid.ids

Hello,

Dan Williams wrote:
> Please also take a look at this cleanup patch that I will queue for
> .28.  I think it makes things easier to read let me know if you
> disagree.
>   

Look good for me. Hmm, actually I don't think that current version is so
hard to read...

Just one comment:

> -	if (!next)
> +	if (dep)
> +		chan = dep->chan;
> +	else
>  		return;
>   

I don't like 'return' inside 'else'.

Regards, Ilya.

