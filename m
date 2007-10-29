From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Sun, 28 Oct 2007 20:21:34 -0400
Message-ID: <4725278E.1050306@tmr.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>	 <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>	 <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com>	 <1193294406.10336.76.camel@firewall.xsintricity.com>	 <20071026091513.GB32550@percy.comedia.it> <1193426793.10336.302.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193426793.10336.302.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> On Fri, 2007-10-26 at 11:15 +0200, Luca Berra wrote:
>   
>> On Thu, Oct 25, 2007 at 02:40:06AM -0400, Doug Ledford wrote:
>>     
>>> The partition table is the single, (mostly) universally recognized
>>> arbiter of what possible data might be on the disk.  Having a partition
>>> table may not make mdadm recognize the md superblock any better, but it
>>> keeps all that other stuff from even trying to access data that it
>>> doesn't have a need to access and prevents random luck from turning your
>>> day bad.
>>>       
>> on a pc maybe, but that is 20 years old design.
>>     
>
> So?  Unix is 35+ year old design, I suppose you want to switch to Vista
> then?
>
>   
>> partition table design is limited because it is still based on C/H/S,
>> which do not exist anymore.
>> Put a partition table on a big storage, say a DMX, and enjoy a 20%
>> performance decrease.
>>     
>
> Because you didn't stripe align the partition, your bad.
>   
Align to /what/ stripe? Hardware (CHS is fiction), software (of the RAID 
you're about to create), or ??? I don't notice my FC6 or FC7 install 
programs using any special partition location to start, I have only run 
(tried to run) FC8-test3 for the live CD, so I can't say what it might 
do. CentOS4 didn't do anything obvious, either, so unless I really 
misunderstand your position at redhat, that would be your bad.  ;-)

If you mean start a partition on a pseudo-CHS boundary, fdisk seems to 
use what it thinks are cylinders for that.

Please clarify what alignment provides a performance benefit.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

