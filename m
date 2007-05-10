From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [PATCH 00/16] raid acceleration and asynchronous offload api
 for 2.6.22
Date: Thu, 10 May 2007 17:32:03 +0200
Message-ID: <46433AF3.1040707@wpkg.org>
References: <4643283B.2060203@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4643283B.2060203@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, rshitrit@marvell.com, dan.j.williams@intel.com, nickpiggin@yahoo.com.au, Justin Piszcz <jpiszcz@lucidpixels.com>, ilmari@ilmari.org
List-Id: linux-raid.ids

Tomasz Chmielewski schrieb:
> Ronen Shitrit wrote:
> 
>> The resync numbers you sent, looks very promising :)
>> Do you have any performance numbers that you can share for these set of
>> patches, which shows the Rd/Wr IO bandwidth.
> 
> I have some simple tests made with hdparm, with the results I don't 
> understand.
> 
> We see hdparm results are fine if we access the whole device:
> 
> thecus:~# hdparm -Tt /dev/sdd
> 
> /dev/sdd:
>  Timing cached reads:   392 MB in  2.00 seconds = 195.71 MB/sec
>  Timing buffered disk reads:  146 MB in  3.01 seconds =  48.47 MB/sec
> 
> 
> But are 10 times worse (Timing buffered disk reads) when we access 
> partitions:

There seems to be another side effect when comparing DMA engine in 
2.6.17-iop1 to 2.6.21-iop1: network performance.


For simple network tests, I use "netperf" tool to measure network 
performance.

With 2.6.17-iop1 and all DMA offloading options enabled (selectable in 
System type ---> IOP3xx Implementation Options  --->), I get nearly 25 
MB/s throughput.

With 2.6.21-iop1 and all DMA offloading optons enabled (moved to Device 
Drivers  ---> DMA Engine support  --->), I get only about 10 MB/s 
throughput.
Additionally, on 2.6.21-iop1, I get lots of "dma_cookie < 0" printed by 
the kernel.


-- 
Tomasz Chmielewski
http://wpkg.org
