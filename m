From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH v3 5/6] md/raid5: activate raid6 rmw feature
Date: Sun, 24 Aug 2014 08:46:48 -0400
Message-ID: <21497.57016.978419.117894@quad.stoffel.home>
References: <5e18e849-8c3d-4812-8fb2-9da8df0ea883@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5e18e849-8c3d-4812-8fb2-9da8df0ea883@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Markus" == Markus Stockhausen <stockhausen@collogia.de> writes:

Markus> md/raid5: activate raid6 rmw feature
Markus> v3: s-o-b comment, performance numbers

Markus> Glue it altogehter. The raid6 rmw path should work the same as the
Markus> already existing raid5 logic. So emulate the prexor handling/flags
Markus> and split functions as needed.

Markus> 1) Enable xor_syndrome() in the async layer.

Markus> 2) Split ops_run_prexor() into RAID4/5 and RAID6 logic. Xor the syndrome
Markus> at the start of a rmw run as we did it before for the single parity.

Markus> 3) Take care of rmw run in ops_run_reconstruct6(). Again process only
Markus> the changed pages to get syndrome back into sync.

Markus> 4) Enhance set_syndrome_sources() to fill NULL pages if we are in a rmw
Markus> run. The lower layers will calculate start & end pages from that and
Markus> call the xor_syndrome() correspondingly.

Markus> 5) Adapt the several places where we ignored Q handling up to now.

Markus> Performance numbers for a single E5630 system with a mix of 10 7200k
Markus> desktop/server disks. 300 seconds random write with 8 threads onto a
Markus> 3,2TB (10*400GB) RAID6 64K chunk without spare (group_thread_cnt=4)

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

My same comments from before still apply.  You need to state which
linux kernel version is the baseline for performance, then explain how
it changes over your patch bundle and which version you're proposing
be made the default moving forward.

As it is, unless I go back and read through a long thread, there's no
easy way to figure this out.

As a suggestion, put the un-patched results in column 1, then as you
add in your patches, show the results, with the final patch showing
the numbers you think give a worth while improvement.  Also, show the
change in percent would be nice as well.  

What tool are you using to generate the test results?  Does it show
good results with 'fio'?  Also, how does the patch look when you have
a simple 4 disk RAID6 array?  I would hope that since the parity
overhead is much higher, it would show more improvement as well.  

Personally, I'm not sure these numbers really show any improvement at
all and I wonder what the error bars are for the results.  I'm sorry
if it seems like I'm slamming your work, it's just that I'm trying to
understand the advantages.

John
