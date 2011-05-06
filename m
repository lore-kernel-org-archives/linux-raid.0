From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 06 May 2011 11:05:56 +0100
Message-ID: <4DC3C804.6080200@abpni.co.uk>
References: <20110506071752.GA22063@www2.open-std.org>	<20110506133159.30c66519@natsu>	<20110506090345.GA22245@www2.open-std.org>	<4DC3BDD9.1060300@abpni.co.uk>	<20110506094102.GC22245@www2.open-std.org> <20110506155059.6f82cbeb@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110506155059.6f82cbeb@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>>> RAID1 is traditionally a mirror only setup (ok, some RAID
>>> implementations may do some load-balancing of some sort). So a RAID1
>>> with 4 disks is one data set copied onto 4 disks. Bandwidth is roughly
>>> the same as a single disk (ignoring any load balancing).
>>> RAID10 is mirror and stripe. A RAID10 with 4 disks is similar to a 2
>>> disk RAID0 (double bandwidth with data split in half across both disks),
>>> but with each disk having a mirror (which brings the total up to 4 drives).
>>>
>>> Additionally, a RAID1 disk (at least using MD) can be accessed just like
>>> a normal disk (good for recovery etc.) however a single disk out of a
>>> RAID10 array is next to useless.
>>>        
>>      
Just so I can sleep at night, is my understanding of RAID10 and RAID1 
above correct?

