From: Mark Lord <liml@rtr.ca>
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Date: Mon, 24 Nov 2008 13:20:26 -0500
Message-ID: <492AF06A.8020004@rtr.ca>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>	<491E4092.5030804@shaw.ca>	<20081115103424.34f01370@lxorguk.ukuu.org.uk>	<491FBA29.3000803@kernel.org> <20081116112511.3913123a@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081116112511.3913123a@lxorguk.ukuu.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alan Cox wrote:
> On Sun, 16 Nov 2008 15:14:01 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> Alan Cox wrote:
>>> On Fri, 14 Nov 2008 21:22:58 -0600
>>> Robert Hancock <hancockr@shaw.ca> wrote:
>>>
>>>> Justin Piszcz wrote:
>>>>> I am trying to find out what the root cause of this error/problem is:
>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=462425
>>>> The problem is that people assume that timeouts with DRDY like that bug 
>>>> refers to must be the same problem when it is often not
>>> The first stopping point is to apply the DRQ drain patch I sent to the
>>> list some time ago and is hopefully lined up for 2.6.29. After that point
>>> you can begin to look at the remaining cases, until then its hardly worth
>>> it.
>> Is it really?  For many SATA controllers, DRQ draining isn't really
>> necessary.  PATA might be a completely different story tho.
> 
> It seems to be needed for various devices and some controllers. Given we
> don't know which it seems to be the sensible starting point for almost any
> failure involving a DRQ being left on. It won't fix them all but it is
> the one case that can easily be eliminated.
..

Well ata_piix for starters.  Verified here by me.

Cheers
