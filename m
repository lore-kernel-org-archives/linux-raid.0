From: Sevrin Robstad <quackyo@start.no>
Subject: Re: bad performance on RAID 5
Date: Thu, 18 Jan 2007 21:47:02 +0100
Message-ID: <45AFDCC6.5030604@start.no>
References: <45AE9640.1040500@start.no> <45AEA550.5070005@lucidpixels.com>
 <45AFBA3E.9070000@start.no>
 <Pine.LNX.4.64.0701181353310.8989@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <Pine.LNX.4.64.0701181353310.8989@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>>>     Chunk Size : 256K
>
> well, that's pretty big.  it means 6*256K is necessary to do a 
> whole-stripe update; your stripe cache may be too small to be effective.
>
>>> If they are on the PCI bus, that is about right, you probably should 
>>> be getting 10-15MB/s, but it is about right.  If you had each drive 
>>> on its own PCI-e controller, then you would get much faster speeds.
>
> 10-15 seems bizarrely low - one can certainly achieve >100 MB/s
> over the PCI bus, so where does the factor of 6-10 come in?
> seems like a R6 resync would do 4 reads and 2 writes for every
> 4 chunks of throughput (so should achieve more like 50 MB/s if the 
> main limit is the bus at 100.)
>
>> There are two controllers, 4 disks connected to one controller on the 
>> PCI-bus and 2 disks connected to the other controller.
>
> well, you should probably look at the PCI topology ("lspci -v -t"),
> and perhaps even the PCI settings (as well as stripe cache size, 
> perhaps nr_requests, etc)
>
>
I've tried to increase the stripe_cache_size a lot, no noticable difference.
I set it to 8096....

[root@compaq md]# lspci -v -t
-[0000:00]-+-00.0  VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333]
           +-01.0-[0000:01]----00.0  ATI Technologies Inc Rage 128 RF/SG AGP
           +-05.0  Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] 
Serial ATA Controller
           +-07.0  Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] 
Serial ATA Controller
           +-08.0  Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet
           +-11.0  VIA Technologies, Inc. VT8233 PCI to ISA Bridge
           \-11.1  VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE
[root@compaq md]#



