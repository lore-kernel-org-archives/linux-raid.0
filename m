From: "David Lethe" <david@santools.com>
Subject: Re: High IO Wait with RAID 1
Date: Fri, 13 Mar 2009 13:02:00 -0500
Message-ID: <407601c9a405$d3d76b6a$e90df40a@exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>, Bill Davidsen <davidsen@tmr.com>
Cc: Alain Williams <addw@phcomp.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----Original Message-----

From:  "Ryan Wagoner" <rswagoner@gmail.com>
Subj:  Re: High IO Wait with RAID 1
Date:  Fri Mar 13, 2009 12:45 pm
Size:  2K
To:  "Bill Davidsen" <davidsen@tmr.com>
cc:  "Alain Williams" <addw@phcomp.co.uk>; "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

Yeah I understand the basics to RAID and the effect cache has on 
performance. It just seems that RAID 1 should offer better write 
performance than a 3 drive RAID 5 array. However I haven't run the 
numbers so I could be wrong. 
 
It could be just that I expect too much from RAID 1. I'm debating 
about reloading the box with RAID 10 across 160GB of the 4 drives 
(160GB and 320GB) and a mirror on the remaining space. In theory this 
should gain me write performance. 
 
Thanks, 
Ryan 
 
On Fri, Mar 13, 2009 at 11:22 AM, Bill Davidsen <davidsen@tmr.com> wrote: 
> Ryan Wagoner wrote: 
>> 
>> I'm glad I'm not the only one experiencing the issue. Luckily the 
>> issues on both my systems aren't as bad. I don't have any errors 
>> showing in /var/log/messages on either system. I've been trying to 
>> track down this issue for about a year now. I just recently my the 
>> connection with RAID 1 and mdadm when copying data on the second 
>> system. 
>> 
>> Unfortunately it looks like the fix is to avoid software RAID 1. I 
>> prefer software RAID over hardware RAID on my home systems for the 
>> flexibility it offers, especially since I can easily move the disks 
>> between systems in the case of hardware failure. 
>> 
>> If I can find time to migrate the VMs, which run my web sites and 
>> email to another machine, I'll reinstall the one system utilizing RAID 
>> 1 on the LSI controller. It doesn't support RAID 5 so I'm hoping I can 
>> just pass the remaining disks through. 
>> 

FYi - you can potentially get  a big performance penalty when running a LSI raid card in jbod mode.  The impact varies depending on a lot of things ..   Try loading the jbod fimware on the card if it supports this and re run benchmarks

david

