From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: How to backup of large md raid volumes?
Date: Fri, 19 May 2017 07:49:43 +0200
Message-ID: <28a4540b-c5ac-bd8d-c030-6d718a02fdfc@thelounge.net>
References: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 18.05.2017 um 23:37 schrieb Ram Ramesh:
> Any one have a method to backup large volumes like md raid6 (16TB)? 
> Since the backup will not fit in one disk (in many cases and mine too) I 
> am wondering, if there is a known/easy technique to backup using 
> multiple usb hard drives. I googed and found a few fancy backup 
> utils/systems like Amanda etc. They are overkill for me. I am choosing 
> not to back up simply because of the complexity of setup as the data in 
> my RAID volume is NOT precious and can be replaced with a week of effort.
> 
> If any one can think of some thing simple, please point me to it and I 
> will do the reading to figure out

https://www.amazon.com/16TB-Desktop-External-Drive-WDBLWE0160JCH-NESN/dp/B01B6BN1CU

499$ is not that much for a 16 TB external backup disk and whn you 
format it with BTRFS and enable compression you most likely have a lot 
fo space and your backup finally is just a single rsync command
