From: Roman Mamedov <rm@romanrm.net>
Subject: RAID6 write I/O amplification?
Date: Tue, 24 Feb 2015 04:58:35 +0500
Message-ID: <20150224045835.14e40dcb@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Got a bit of a "how does it actually work" question...

Suppose I have an MD RAID6 of 8 drives, with 64KB chunk size.

I am rewriting a 4KB filesystem sector somewhere on that RAID (not crossing
the stripe boundary).

What's the amount of disk I/O in total this will result in?

I assume the RAID will need to read data from all drives, recompute parity,
then write to the data stripe where the updated piece happened to be, and also
write to two parity stripes.

Is this done at a stripe granularity, so 6x64KB reads, 3x64KB writes?
Or down to individual sectors (pages), i.e. 6x4KB reads, 3x4KB writes?
Or am I describing this algorithm correctly at all?

-- 
With respect,
Roman
