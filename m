From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID1 == two different ARRAY in scan, and Q on read error corrected
Date: Sat, 19 Apr 2008 15:15:28 +1200
Message-ID: <480963D0.70307@sauce.co.nz>
References: <27567.1208547359@perkpartners.com> <48091A67.1090906@sauce.co.nz> <A20315AE59B5C34585629E258D76A97C087DAB@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C087DAB@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Lethe wrote:
> You can't assume a disk is losing sectors and failing without running
> some diagnostics. If you had an improper shutdown (i.e, power loss, not
> a crash), and disks were writing, then you can get ECC errors.  That
> does not indicate the disk is bad.

The error was:

Apr 18 14:01:45  smartd[2104]: Device: /dev/sdc, 3 Currently unreadable 
(pending) sectors

These are not ECC errors and the definition I have for pending sector 
errors is, "Current count of unstable sectors (waiting for remapping)."

It would be useful to see the Reallocated Sectors Count from the 
smartctl output.

Regards,

Richard
