From: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Date: Sun, 16 Nov 2008 15:14:01 +0900
Message-ID: <491FBA29.3000803@kernel.org>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>	<491E4092.5030804@shaw.ca> <20081115103424.34f01370@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081115103424.34f01370@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alan Cox wrote:
> On Fri, 14 Nov 2008 21:22:58 -0600
> Robert Hancock <hancockr@shaw.ca> wrote:
> 
>> Justin Piszcz wrote:
>>> I am trying to find out what the root cause of this error/problem is:
>>> https://bugzilla.redhat.com/show_bug.cgi?id=462425
>> The problem is that people assume that timeouts with DRDY like that bug 
>> refers to must be the same problem when it is often not
> 
> The first stopping point is to apply the DRQ drain patch I sent to the
> list some time ago and is hopefully lined up for 2.6.29. After that point
> you can begin to look at the remaining cases, until then its hardly worth
> it.

Is it really?  For many SATA controllers, DRQ draining isn't really
necessary.  PATA might be a completely different story tho.

-- 
tejun
