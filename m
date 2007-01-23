From: "kyle" <kylewong@southa.com>
Subject: Re: change strip_cache_size freeze the whole raid
Date: Tue, 23 Jan 2007 22:22:51 +0800
Message-ID: <009101c73ef9$fdb561d0$28df0f3d@kylecea1512a3f>
References: <001801c73e14$c3177170$28df0f3d@kylecea1512a3f> <Pine.LNX.4.64.0701220717200.30260@p34.internal.lan> <45B4D0ED.7030500@maine.edu> <Pine.LNX.4.64.0701221000330.1711@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933001AbXAWOXP@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Steve Cousins <steve.cousins@maine.edu>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> I can try and do this later this week possibly.

> Justin.
>>
>> alt-sysrq-T or "echo t > /proc/sysrq-trigger" can be really helpful to
>> diagnose this sort of problem (providing the system isn't so badly
>> stuck that the kernel logs don't get stored).
>>
>> It is probably hitting a memory-allocation deadlock, though I cannot
>> see exactly where the deadlock would be.  If you are able to reproduce
>> it and can get the kernel logs after 'alt-sysrq-T' I would really
>> appreciate it.
>> Justin,Maybe you can try freeze it once more and get the kernel logs 
>> before try Neil's patch ...... :D~Kyle 
