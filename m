From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: My MD is too big to resize ext4.
Date: Sat, 8 Jul 2017 13:48:54 -0500
Message-ID: <8fad2a40-6b5d-fcb1-ec65-5518517b1296@gmail.com>
References: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
 <02786811-5d00-af90-adfd-82ae3f9f0781@fnarfbargle.com>
 <f4e57040-177d-39b9-ee30-95b82b1ac15a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f4e57040-177d-39b9-ee30-95b82b1ac15a@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>> I had this issue a few years ago and decided buying some extra disks 
>> to use as scratch was a better move for me. In your shoes I would 
>> have found 6 extra SATA ports on a machine (any machine), created the 
>> new filesystem and rsynced the data across, then swapped the disks 
>> into the production machine.

Brad,

   I try to keep disks from different production batch in my MD as 
proabilistically speaking, this is safe. This means I buy one disk every 
year and replace the oldest one. This time it is special case that My 
last 3TB got replaced with new 6TB and now I can actually expand the 
array.  So, the above method may not always work for me. However, I see 
your point and therefore see merit to it. In any case, I am taking 
Andreas (and few others)  advice and try to build several smaller MD 
devices instead of one large one. I responded to him on this idea. Let 
me see if any one sees issues with that.

Ramesh

