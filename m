From: Brad Campbell <brad@wasp.net.au>
Subject: Re: RAID-6: help wanted
Date: Sun, 24 Oct 2004 09:26:17 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <417B3CF9.7090107@wasp.net.au>
References: <cleqh6$ps4$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cleqh6$ps4$1@terminus.zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> Okay, it's well overdue to do this...
> 
> There is currently a data-corruption bug in the RAID-6 md layer
> (raid6main.c).  I have so far not been successful in locating it,
> although it is easily reproducible, thanks to a set of scripts by Jim
> Paris.  I suspect it is a race condition between raid6d and the rest
> of the kernel.
> 
> The problem is that I already have way too many projects in flight,
> and I *really* would like to focus the time I have on getting
> klibc/early userspace integrated.  Thus, I don't expect to have any
> time at chasing the RAID-6 corruption bug any time soon.
> 
> What can be ruled out is errors in the RAID-6 algorithm codes,
> however.  Those are easily testable in isolation and have a clean bill
> of health.

Great, can we get a copy of the scripts to try and assist?

Brad
