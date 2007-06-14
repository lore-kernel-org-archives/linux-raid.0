From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: SLES 9 SP3 and mdadm 2.6.1 (via rpm)
Date: Thu, 14 Jun 2007 04:22:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706140421550.25392@p34.internal.lan>
References: <20070612072408.19140@gmx.net> <18030.19615.898281.457910@notabene.brown>
 <20070613114553.235550@gmx.net> <Pine.LNX.4.64.0706130749390.31068@p34.internal.lan>
 <20070614075336.GB7134@percy.comedia.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070614075336.GB7134@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 14 Jun 2007, Luca Berra wrote:

> On Wed, Jun 13, 2007 at 07:50:06AM -0400, Justin Piszcz wrote:
>> You don't even need that, just do this:
>> 
>> 1. echo 'DEVICE /dev/hd*[0-9] /dev/sd*[0-9]' > mdadm.conf
> do _NOT_ do the above, _never_.
> recent mdadm do not need the "DEVICE" line
> for older one use "DEVICE partitions".
>
> -- 
> Luca Berra -- bluca@comedia.it
>       Communication Media & Services S.r.l.
> /"\
> \ /     ASCII RIBBON CAMPAIGN
> X        AGAINST HTML MAIL
> / \
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Why never do that? It has always worked for me.

Justin.
