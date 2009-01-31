From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.28: All I/O, D-state: 3ware
 9650SE-16ML/Intel/965/MTRR/PAT?
Date: Sat, 31 Jan 2009 18:11:41 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901311811140.19833@p34.internal.lan>
References: <alpine.DEB.1.10.0901310523480.29879@p34.internal.lan> <alpine.DEB.1.10.0901311230510.4472@p34.internal.lan> <20090131175509.GA24900@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090131175509.GA24900@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com
List-Id: linux-raid.ids



On Sat, 31 Jan 2009, Christoph Hellwig wrote:

> On Sat, Jan 31, 2009 at 12:37:39PM -0500, Justin Piszcz wrote:
>> I think it was a coincidence when I tried to login before, I tried it
>> again (after trying to re-produce the problem, which I had been able to
>> do) and this time the mouse worked but the keyboard did not..even running
>> echo b > sysrq-trigger did not reboot the server..  Had to resort to
>> manual method.
>>
>> I am now on kernel 2.6.28.2 and will see if I can make it happen again.
>
> This looks like the bug fixed by commit
> e8c82c2e23e3527e0c9dc195e432c16784d270fa.  Make sure you have it.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks, looks like that was the culprit, no hangs in 1-2 hrs of heavy I/O.

Justin.
