From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: Re: One Large md or Many Smaller md for Better Peformance?
Date: Mon, 21 Jan 2008 02:41:41 -0800
Message-ID: <0322CB2B-6019-47CD-A1AC-76A5DE1367FA@develooper.com>
References: <4793AE0E.609@pobox.com> <4793C8C0.3010301@tmr.com>
Mime-Version: 1.0 (Apple Message framework v915)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4793C8C0.3010301@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 20, 2008, at 2:18 PM, Bill Davidsen wrote:

> One partitionable RAID-10, perhaps, then partition as needed. Read  
> the discussion here about performance of LVM and RAID. I personally  
> don't do LVM unless I know I will have to have great flexibility of  
> configuration and can give up performance to get it. Other report  
> different results, so make up your own mind.


On MySQL servers I always always use LVM, even if performance is  
critical there: Snapshots!  They make it easy and efficient to do an  
online snapshot after just freezing the database for a second or three.


  - ask

[1] http://lenz.homelinux.org/mylvmbackup/

-- 
http://develooper.com/ - http://askask.com/


