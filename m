From: Derek Vadala <derek@cynicism.com>
Subject: Re: Partitioning a RAID device
Date: Wed, 4 Sep 2002 09:13:56 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0209040912270.11782-100000@jaded.cynicism.com>
References: <Pine.HPX.4.43.0209041432440.11531-100000@electra.kip.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.HPX.4.43.0209041432440.11531-100000@electra.kip.uni-heidelberg.de>
To: Arne Wiebalck <wiebalck@kip.uni-heidelberg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 4 Sep 2002, Arne Wiebalck wrote:

> is it possible to have partitions on a RAID device?
>
> [...]
>
> Anything I am missing here?

You first need to patch your kernel so that the md driver and md devices
support partitioning. Check out
http://cgi.cse.unsw.edu.au/~neilb/patches/linux-stable/ for the patches.


---
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

