From: Nat Makarevitch <nat@makarevitch.org>
Subject: Re: RAID10 far (f2) read throughput on random and sequential / read-ahead
Date: Sun, 24 Feb 2008 00:09:59 +0000 (UTC)
Message-ID: <loom.20080224T000728-690@post.gmane.org>
References: <loom.20080222T035556-308@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nat Makarevitch <nat <at> makarevitch.org> writes:

> 'md' performs wonderfully

> random access performance remains stable and high (450
> IOPS with 48 threads, 20% writes - 10% fsync'ed), even with a fairly high
> read-ahead (16k).

Mystery solved, sorry for the noise

Explanation: I use the 'randomio' tool and searched in its sourcecode for the
various 'advise' calls (posix_fadvise(2), madvise(2)...) and forgot to check the
open call (it uses O_DIRECT!)


