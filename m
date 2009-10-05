From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: ANNOUNCE: mdadm 3.0.1 - A tool for managing Soft RAID under
 Linux
Date: Mon, 5 Oct 2009 09:40:47 -0800 (AKDT)
Message-ID: <alpine.LNX.2.01.0910050939250.14238@filesrv1.baby-dragons.com>
References: <19132.27836.474548.540600@notabene.brown> <alpine.LNX.2.01.0910041514180.11684@filesrv1.baby-dragons.com> <4AC9C0A0.8070709@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AC9C0A0.8070709@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello Michael ,

On Mon, 5 Oct 2009, Michael Tokarev wrote:
> Mr. James W. Laferriere wrote:
>>     Hello Neil (& All) ,  Am I missing something here ?  I've not had much 
>> if any difficulties compiling mdadm ,  from -very- old distro. tooled boxen 
>> to very new ,  But ...
> []
>> monitor.c: In function `signal_manager':
>> monitor.c:139: error: `SYS_tgkill' undeclared (first use in this function)
>> monitor.c:139: error: (Each undeclared identifier is reported only once
>> monitor.c:139: error: for each function it appears in.)
>> make: *** [monitor.o] Error 1
>> 
>> # uname -a
>> Linux ns3 2.6.30.6 #1 SMP Wed Sep 9 05:50:45 UTC 2009 i686 pentium3 i386 
>> GNU/Linux
>
> If you use that new kernel, how about updating kernel-headers
> to match your kernel?  SYS_tgkill comes from linux headers.
 	Cool ,  Thank you .

>> # /usr/src/linux/scripts/ver_linux
>
> that's all fine except it does not show
> version of kernel headers installed on
> your system.  Or the "counterpart" from
> the glibc.
> /mjt
 	Is there a Kernel provided tool to determine what versions of each are 
in place on a system ?

 	Tia ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
