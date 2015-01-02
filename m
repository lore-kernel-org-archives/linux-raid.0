From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Fri, 02 Jan 2015 10:38:41 -0800
Message-ID: <54A6E5B1.2090602@tigertech.com>
References: <20150102130101.GC6294@deb76.aryehleib.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150102130101.GC6294@deb76.aryehleib.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/2/15 5:01 AM, Aryeh Leib Taurog wrote:

> While doing this I discovered one of the usb cables is flaky, which 
> explains why the device (sdc below) wasn't always coming on line.

Okay, that's probably the source of the problem, then. One of the times
when you restarted, only the non-flaky one was available. That made md
assemble the array with only that member, increasing the event count on
that partition. So now the partitions are "different" (although perhaps
you didn't change the data on them if you never mounted the array after
the problem started).

Your question is about how to reassemble them without a resync, which is
understandable, but the reason md isn't doing that automatically is that
it thinks they might be different.

I personally would always do a resync in such a case. A flaky cable
suggests that data on it is suspect, and this is one of the things RAID
1 is for: it allows you to copy clean data to suspect partitions.

But I'm known to be data-paranoid. Other people may have different
opinions/suggestions.

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
