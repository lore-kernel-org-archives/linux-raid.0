From: "John Stoffel" <john@stoffel.org>
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports Raid Level Migration and Online Capacity Expansion
Date: Thu, 22 Dec 2005 15:15:10 -0500
Message-ID: <17323.2382.350576.347316@smtp.charter.net>
References: <200512221707.jBMH7PCS028943@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200512221707.jBMH7PCS028943@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Andrew" == Andrew Burgess <aab@cichlid.com> writes:

>> 3) Performance issues:  I'm currently thinking of
>> using either RAID 10 or LVM2 with RAID 5 to serve as a
>> RAID server.

Andrew> I think you always want LVM2 between raid and the
Andrew> filesystem. Not only can you expand things but you can discard
Andrew> older raid arrays when you upgrade. At least you should study
Andrew> the docs for LVM to see if it would be good for your
Andrew> application.

I agree with this, having LVM between MD and the filesystem lets you
move the data from one MD to another without any major downtime or
even your users having to notice.  Which is cool.  

I really really like ext3 for it's reliability, but a filesystem which
you can grow/shrink while mounted would be nice.  I really like VxFS
from Veritas, but obviously you won't find it one Linux right now.  

I've been tempted by XFS at times, but I worry, esp since alot of
other people who are core developers don't care for XFS as much.  But
maybe I'll move that way for my next system.

John
