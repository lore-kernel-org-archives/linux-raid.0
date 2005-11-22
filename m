From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Poor Software RAID-0 performance with 2.6.14.2
Date: Tue, 22 Nov 2005 13:23:16 -0500
Message-ID: <43836214.4010200@steeleye.com>
References: <4ad99e050511211231o97d5d7fw59b44527dc25dcea@mail.gmail.com> <438354B4.10604@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <438354B4.10604@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Lars Roland <lroland@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux RAID M/L <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bill Davidsen wrote:

> One of the advantages of mirroring is that if there is heavy read load 
> when one drive is busy there is another copy of the data on the other 
> drive(s). But doing 1MB reads on the mirrored device did not show that 
> the kernel took advantage of this in any way. In fact, it looks as if 
> all the reads are going to the first device, even with multiple 
> processes running. Does the md code now set "write-mostly" by default 
> and only go to the redundant drives if the first fails?

No, it doesn't use write-mostly by default. The way raid1 read balancing 
works (in recent kernels) is this:

- sequential reads continue to go to the first disk

- for non-sequential reads, the code tries to pick the disk whose head 
is "closest" to the sector that needs to be read

So even if the reads aren't exactly sequential, you probably still end 
up reading from the first disk most of the time. I imagine with a more 
random read pattern you'd see the second disk getting used.

--
Paul
