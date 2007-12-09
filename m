From: Michael Makuch <linuxraid@makuch.org>
Subject: Re: /proc/mdstat docs (was Re: Few questions)
Date: Sat, 08 Dec 2007 22:11:24 -0600
Message-ID: <475B6AEC.80203@makuch.org>
References: <4759E13F.7000308@makuch.org> <475AD13C.3060203@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <475AD13C.3060203@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Michael Makuch wrote:
>   
>> So my questions are:
>>     
> ...
>   
>> - Is this a.o.k for a raid5 array?
>>     
>
> So I realised that /proc/mdstat isn't documented too well anywhere...
>
> http://linux-raid.osdl.org/index.php/Mdstat
>
> Comments welcome...
>
> David
>   

One thing, in the section "md device line" you describe how to identify 
spare devices,
but you didn't mention the "(S)" which appears after a spare device, at 
least it does on mine:

# uname -a
Linux pecan.makuch.org 2.6.23.1-21.fc7 #1 SMP Thu Nov 1 21:09:24 EDT 
2007 i686 i686 i386 GNU/Linux

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 etherd/e0.0[0] etherd/e0.2[9](S) etherd/e0.9[8] 
etherd/e0.8[7] etherd/e0.7[6] etherd/e0.6[5] etherd/e0.5[4] 
etherd/e0.4[3] etherd/e0.3[2] etherd/e0.1[1]
      3907091968 blocks level 5, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]
      [==================>..]  resync = 91.0% (444527040/488386496) 
finish=560.9min speed=1301K/sec
unused devices: <none>


Unless that means something else??? But e0.2 is my spare so I'm just 
assuming "(S)" means spare!

Thanks
Mike


