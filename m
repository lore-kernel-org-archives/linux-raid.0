From: Bill Davidsen <davidsen@tmr.com>
Subject: RAID-6
Date: Wed, 16 Nov 2005 12:54:44 -0500
Message-ID: <437B7264.50506@tmr.com>
References: <437701DE.7060400@wasp.net.au> <17271.4092.24066.572971@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17271.4092.24066.572971@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Based on some google searching on RAID-6, I find that it seems to be 
used to describe two different things. One is very similar to RAID-5, 
but with two redundancy blocks per stripe, one XOR and one CRC (or at 
any rate two methods are employed). The other sources define RAID-6 as 
RAID-5 with a distributed hot spare, AKA RAID-5E, which spreads head 
motion to all drives for performance.

Any clarification on this?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

