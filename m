From: Mark Bellon <mbellon@mvista.com>
Subject: Re: No response?
Date: Thu, 20 Jan 2005 12:41:57 -0700
Message-ID: <41F00985.3090105@mvista.com>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu> <Pine.LNX.4.56.0501201805070.12589@lion.drogon.net> <41EFFA53.3030809@mvista.com> <Pine.LNX.4.56.0501201933180.12589@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0501201933180.12589@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:

>On Thu, 20 Jan 2005, Mark Bellon wrote:
>
>  
>
>>I've seen this too. The worst case can actually last for over 2 minutes.
>>
>>We've been running with a patch to the RAID 1 driver that handles this
>>so critical applications do not hang for too long. Basically it uses
>>timers in the RAID 1 driver to force the disk to be treated as actually
>>having failed if it doesn't respond within a reasonable time (tunable
>>but usually ~3 seconds). It then handles the I/O requests coming back
>>async. and does the clean up.
>>    
>>
>
>This is intersting, but make it an option (kernel compile, sysctl,
>etc.)... I have a small home server/firewall that I run with the disks
>spun down (noflushd) and spinning up a disk sometimes takes 8 seconds -
>it's a RAID-1 set and seems to cope OK with the disks spinning down & up
>again as required...
>  
>
The current patch has config options to adjust the 
Non-Responsive-Disk-Timer. A zero specified no timeout and a non-zero 
value is the timeout in seconds.

Let me pull a 2.4.26 kernel source and see how fast I can work up a 
patch. Or would it better to generate it against 2.4.29?

mark

>Gordon
>  
>

