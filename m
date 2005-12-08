From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 resync question BUGREPORT!
Date: Fri, 9 Dec 2005 10:43:38 +1100
Message-ID: <17304.50474.390938.734714@cse.unsw.edu.au>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs>
	<17300.56329.638969.509384@cse.unsw.edu.au>
	<004201c5f9fe$50cc41a0$0400a8c0@dcccs>
	<17300.58327.193597.248431@cse.unsw.edu.au>
	<035b01c5fc4b$416c98f0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Friday December 9
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 9, djani22@dynamicweb.hu wrote:
> Hello, Neil,
> 
> [root@st-0001 mdadm-2.2]# mdadm --grow /dev/md0 --bitmap=internal
> mdadm: Warning - bitmaps created on this kernel are not portable
>   between different architectured.  Consider upgrading the Linux kernel.
> 
> Dec  8 23:59:45 st-0001 kernel: md0: bitmap file is out of date (0 <
> 81015178) -- forcing full recovery
> Dec  8 23:59:45 st-0001 kernel: md0: bitmap file is out of date, doing full
> recovery
> Dec  8 23:59:46 st-0001 kernel: md0: bitmap initialized from disk: read
> 12/12 pages, set 381560 bits, status: 0
> Dec  8 23:59:46 st-0001 kernel: created bitmap (187 pages) for device md0
> 
> And the system is crashed.
> no ping reply, no netconsole error logging, no panic and reboot.

Hmmm, that's unfortunate :-(

Exactly what kernel were you running?

NeilBrown
