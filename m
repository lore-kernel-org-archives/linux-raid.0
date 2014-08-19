From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH v2 0/6] raid6: support read-modify-write
Date: Tue, 19 Aug 2014 19:46:41 -0400
Message-ID: <21491.57825.401637.881344@quad.stoffel.home>
References: <677cbe3b-4301-4650-962a-043f6ae59086@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <677cbe3b-4301-4650-962a-043f6ae59086@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Markus" == Markus Stockhausen <stockhausen@collogia.de> writes:

Markus> 300 seconds random write with 8 threads
Markus> 3,2TB (10*400GB) RAID6 64K chunk without spare 
Markus> group_thread_cnt=4

Markus> bsize   rmw_level=1   rmw_level=0   rmw_level=1   rmw_level=0
Markus>         skip_copy=1   skip_copy=1   skip_copy=0   skip_copy=0
Markus>    4K      115 KB/s      141 KB/s      165 KB/s      140 KB/s
Markus>    8K      225 KB/s      275 KB/s      324 KB/s      274 KB/s
Markus>   16K      434 KB/s      536 KB/s      640 KB/s      534 KB/s
Markus>   32K      751 KB/s    1,051 KB/s    1,234 KB/s    1,045 KB/s
Markus>   64K    1,339 KB/s    1,958 KB/s    2,282 KB/s    1,962 KB/s
Markus>  128K    2,673 KB/s    3,862 KB/s    4,113 KB/s    3,898 KB/s
Markus>  256K    7,685 KB/s    7,539 KB/s    7,557 KB/s    7,638 KB/s
Markus>  512K   19,556 KB/s   19,558 KB/s   19,652 KB/s   19,688 Kb/s

Which is the current 3.16.0 implementation?  I can't keep it straight
in my head and you don't clearly specify which set is what we have
now, and which is your patch and it's option(s) in place.

What type of system did you run this test on?  How much CPU/RAM, etc?
Can you should the configuration of the filesystem/MD volume you wrote
too as well?  Sorry to be picky here, I'm just trying to see what this
buys us.  Were the disks using SATA?  IDE?  What speed are the disks?  

Also, how does the SSE2 optimization work?  Can it be turned on/off?
And how much speedup does it provide?  

Otherwise, I don't see any huge improvements with the  numbers, and
the only consistent win is the rmw_level=1, skip_copy=0 case.  But
even then when the bsize is big enough it's slower than other
options.  So is it a win overall?

John
