From: MRK <mrk@shiftmail.org>
Subject: Re: Linux Raid performance
Date: Mon, 05 Apr 2010 13:20:14 +0200
Message-ID: <4BB9C76E.7080607@shiftmail.org>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>
 <20100331201539.GA19395@rap.rap.dk>
 <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
 <20100402110506.GA16294@rap.rap.dk>
 <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com>
 <l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com>
 <4BB69670.3040303@sauce.co.nz> <4BB7856C.30808@shiftmail.org>
 <4BB79D76.7090206@sauce.co.nz> <4BB8A979.3020502@shiftmail.org>
 <4BB91FBC.10504@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4BB91FBC.10504@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Mark Knecht <markknecht@gmail.com>, Learner Study <learner.study@gmail.com>, linux-raid@vger.kernel.org, keld@dkuug.dk
List-Id: linux-raid.ids

Richard Scobie wrote:
> MRK wrote:
>
>> If this is so, the newer LSI controllers at 6.0gbit/sec could be able to
>> do better (they supposedly have a faster chip). Also maybe one could buy
>> more controller cards and divide drives among those. These two
>
> Yes, both of these would work.
>
> Someone posted previously on this list and was writing at 1.7GB/s 
> using 10 x 15K SAS drives md RAID0. He did mention the troughput was 
> higher with the LSI SAS2 cards, even with SAS1 port expanders connected.

Not so fast... actually I see a problem with previous deduction of what 
is the bottleneck.

The answer from the LSI engineer leads to think that the bottleneck with 
SATA is the number of IOPS, it's because there are 5 connections 
established and then broken for each I/O. And this is independent from 
the size transferred by each I/O operation via DMA (the overhead of the 
data transfer is the same in SAS and SATA case, it's always the same DMA 
chip doing the transfer).

However, if really the total number of IOPS is the bottleneck in SATA 
with the 3.0gbit/sec LSI cards, why they don't slow down a single SSD 
doing 4k random I/O?

Look at this
http://www.anandtech.com/show/2954/5
OCZ vertex LE doing 162 MB/sec at 4K aligned random writes, that means 
41472 IOPS, independent and unmergeable requests. And that is SATA not SAS.
This is on Windows. Unfortunately we don't know the controller which was 
used for this benchmark.

During MD-RAID sequential dd write I have seen linux (via iostat -x 1) 
merging requests by a factor at least 400 (sometimes much higher), so I 
suppose requests issued to the controller would be at least 1.6 MB long 
(original requests are certainly not shorter than 4K, and 4K x 400=1.6MB).

If the system tops out at about 600MB/sec and writes issued are 1.6MB 
long or more, it means that the controller tops out at 375 IOPS or less.

So how come the controller of the anandtech test above is capable of 
doing 41472 IOPS?


This is also interesting:

Richard Scobie wrote:
> This bottleneck is the SAS controller, at least in my case. I did the 
> same math regarding streaming performance of one drive times number of 
> drive and wondered where the shortfall was, after tests showed I could 
> only streaming read at 850MB/s on the same array. 
I think if you use dd to read from the 16 underlying devices 
simultaneously, independently, and not using MD, (output to /dev/null) 
you should obtain the full disk speed of 1.4 GB/sec or so (aggregated). 
I think I did this test in the past and I noticed this. Can you try? I 
don't have our big disk array in my hands any more :-(

