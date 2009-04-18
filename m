From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Proposal: make RAID6 code optional
Date: Sat, 18 Apr 2009 12:09:54 +0400
Message-ID: <49E98AD2.8060601@msgid.tls.msk.ru>
References: <200904180946.27722.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200904180946.27722.prakash@punnoor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Prakash Punnoor <prakash@punnoor.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Prakash Punnoor wrote:
> Hi,
> 
> as I am using only RAID5 I wonder why the RAID6 code also needs to be built.
> Here is a rough patch of making RAID6 optional (but depending on raid456)
> without reording of functions to minimize ifdef scattering.
> (I also haven't checked yet who needs ASYNC_MEMCPY and ASYNC_XOR...)
> It would probably be nicer to make RAID4/5 and RAID6 independently selectable
> of each other. But that requires more refactoring, as I can see.

Hm.  In "old good days" there were 3 independent kernel modules,
named raid4, raid5 and raid6.  Later on, they got merged into one
since they share quite alot of the code, and has only a few specific
parts.  Now you're trying to separate them back somewhat....

What's your goal?  What's the problem you're trying to solve?

/mjt
