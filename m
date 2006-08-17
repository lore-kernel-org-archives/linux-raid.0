From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: spurious dots in dmesg when reconstructing arrays
Date: Thu, 17 Aug 2006 16:15:13 +0400
Message-ID: <44E45DD1.4080608@tls.msk.ru>
References: <44E447E0.9020006@tls.msk.ru> <17636.22183.827402.227427@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17636.22183.827402.227427@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday August 17, mjt@tls.msk.ru wrote:
>> A long time ago I noticied pretty bad formatting of
>> dmesg text in md array reconstruction output, but
>> never bothered to ask.  So here it goes.
> 
> What kernel version?
> My patch logs suggest that I fixed that about 1 year ago...
> which means it is still in SLES9 at least :-)

Okay, er, me bad.  I was looking at the 2.6.17 source trying
to find that dot, but the kernel from which the messages are
is 2.6.11-based, which is indeed more than a year old.  Sure
I can't find where that dot is coming from in 2.6.17! ;)
Oh well.

Thank you, and sorry for the noise.

/mjt
