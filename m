From: Brad Campbell <brad@wasp.net.au>
Subject: Raidreconf and raid-6
Date: Tue, 23 Mar 2004 17:25:59 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40603AE7.4050301@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

G'day all,

I'm in the middle of adding journaling to raidreconf to try and make it resilient to any failures
except hard disk failures (Power fails, reboots and that kind of thing). It's not pretty, and it
slows the process down something chronic but hopefully it will make the process bulletproof.

While I'm here I'm looking at trying to add raid-6 support also. I have had a pretty good trawl
through the raid-6 kernel code and given raidreconf does not do anything with parity blocks it looks
pretty similar to raid-5 from that respect.
Are there any gotchas that anyone can think of I should look out for that may trip me up with the
difference between raid5 & 6 ?

I figure if you could do an easy conversion between raid-5 and raid-6 it might speed up testing and
adoption of raid-6.

Regards,
Brad

