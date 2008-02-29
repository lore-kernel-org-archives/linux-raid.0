From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Severe slowdown with LVM on RAID, alignment problem?
Date: Fri, 29 Feb 2008 11:37:58 +0100
Message-ID: <47C7E086.5080203@rabbit.us>
References: <872d9b69db95a1b08319e935595743cc@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <872d9b69db95a1b08319e935595743cc@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guntsche <mike@it-loops.com>
Cc: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Guntsche wrote:
> 
> Is it possible that my computer is just too slow to get good read results?
unlikely

> While reading is a little bit faster it's nowhere near the speed I get on
> md0 itself.
> 

I would guess that you did not set the correct read-ahead values for the LV. 
If you do not specify anything it will default to 128k (256 sectors), which is 
terribly small for sequential reads. On the contrary the MD device will do 
some clever calculations and set its read-ahead correctly depending on the 
raid level and the number of disks. Do:

blockdev --setra 65536 <your lv device>

and run the tests again. You are almost certainly going to get the results you 
are after.

Peter
