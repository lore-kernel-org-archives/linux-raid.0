From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: detection/correction of corruption with raid6
Date: Fri, 5 Dec 2008 16:02:41 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812051602110.17806@p34.internal.lan>
References: <1228510833.16555.76.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1228510833.16555.76.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 5 Dec 2008, Redeeman wrote:

> Hello.
>
> I was looking at the PDFs linked to from the wiki, and found this:
> http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
>
> More specifically, section 4, starting on page 8.
>
> Am I understanding this correctly, in that with raid6, linux is capable
> of detecting if the content on 1 disk is corrupted, and reconstruct it
> from the remaining disks?

I ran md/raid6 for awhile, do you mean remap the bad sector on the fly? 
Linux/md raid does not do this afaik.

But it can recover from a single or double disk failure, I have had both 
happen.

Justin.
