From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Wed, 22 Jan 2014 17:48:20 -0700
Message-ID: <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52DFA01E.8000301@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 22, 2014, at 3:40 AM, David Brown <david.brown@hesbynett.no> wrote:
> 
> If the raid system reads in the whole stripe, and finds that the
> parities don't match, what should it do?  

https://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
page 8 shows how it can be determined whether data, or P, or Q are corrupt. Multiple corruptions could indicate if a particular physical drive is the only source of corruptions and then treat it as an erasure. Using normal reconstruction code, the problem is correctable. But I'm uncertain if this enables determination of the specific device/chunk when there is data corruption within a single stripe.

It seems there's still an assumption that if data chunks produce P' and Q' which do not match P or Q, that P and Q are both correct which might not be true.

> Before considering what checks
> can be done, you need to think through what could cause those checks to
> fail - and what should be done about it.  If the stripe's parities don't
> match, then something /very/ bad has happened - either a disk has a read
> error that it is not reporting, or you've got hardware problems with
> memory, buses, etc., or the software has a serious bug.

Yes but we know that these things actually happen, even if rare. I don't know how common ECC fails to detect error, or detects but wrongly corrects, but we know that there are (rarely) misdirected writes. That not lonly obliterates data that might have been stored where the data landed, but it also means it's missing where it's expected. Neither drive nor controller ECC helps in such cases.

>  In any case,
> you have to question the accuracy of anything you read off the array -
> you certainly have no way of knowing which disk is causing the trouble.

I'm not certain. From the Anvin paper, equation 27 suggests it's possible to know which disk is causing the trouble. But I don't know if that equation is intended for physical drives corrupting a mix of data, P and Q parities - or if it works to isolate the specific corrupt data chunk in a single (or more correctly, isolated) stripe data/parity mismatch event.

I think in the case of a single, non-overlapping corruption in a data chunk, that RS parity can be used to localize the error. If that's true, then it can be treated as a "read error" and the normal reconstruction for that chunk applies.

> Probably the best you could do is report the whole stripe read as
> failed, and hope that the filesystem can recover.

With default chunk size of 512KB that's quite a bit of data loss for a file system that doesn't use checksummed metadata.


Chris Murphy

