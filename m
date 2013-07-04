From: Phil Turmel <philip@turmel.org>
Subject: Re: question about the best suited RAID level/layout
Date: Thu, 04 Jul 2013 17:43:38 -0400
Message-ID: <51D5EC8A.40509@turmel.org>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372961877.8716.43.camel@heisenberg.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/04/2013 02:17 PM, Christoph Anton Mitterer wrote:
> Hi.
> 
> I'm setting up a 5-bay NAS (based on a QNAP device), with my personal
> Debian on it, currently using only 4 devices though
> The focus is absolutely on data security/resilience,... and not at all
> on performance.

This particular statement trumps all other considerations.

> Now questions comes, which RAID level to use, and I guess with the main
> focus on resilience there's only basically these options:

[snip /]

You covered all the basics.

From your own analysis, raid6 is the option that maximizes total storage
while achieving an "any two failures" resiliency.  Triple-copy raid10
across four drives can match that resiliency, with dramatically better
performance, but with a substantial cost in capacity.

Two-failure resilience is vital to completing recovery after replacing a
failed drive, particularly when the read error rates of consumer-grade
drives are involved.

In your specific case, raid6 has one additional advantage: making future
expansion to the fifth bay a reliable, simple, no downtime event.

In your situation, I would use raid6.  To mitigate the performance hit
on occasional random-access work, I would use a small chunk size (I use
16k).  That will somewhat hurt peak linear performance, but even
bluray-equivalent media streams only amount to 5 MB/s or so.  That would
be 80 IOPS per device in such a four-drive raid6.

Phil
