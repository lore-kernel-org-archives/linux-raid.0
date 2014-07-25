From: George Rapp <george.rapp@gmail.com>
Subject: Re: Fedora 20 RAID 6 errors on rebuild / check / repair
Date: Fri, 25 Jul 2014 12:57:34 -0400
Message-ID: <CAF-KpgZRHUf3UjarndNXourz0i8MeEhz7P4qRYJhVYQoTJfuLg@mail.gmail.com>
References: <CAF-KpgZ+8pPp62CN5p4rkwSk0nSv_JdkXGLnUWMaDEj2MmVcGg@mail.gmail.com>
 <53D0B6C1.7030908@uni-konstanz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53D0B6C1.7030908@uni-konstanz.de>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 24, 2014 at 3:33 AM, Kay Diederichs
<kay.diederichs@uni-konstanz.de> wrote:
> On 07/24/2014 04:29 AM, George Rapp wrote:
>> Hi -
>> [big snip]
>>

Kay

Thanks for your feedback. I'll try to address the details of what you
asked below.

> this is not necessarily a RAID problem. Can you exclude the possibility
> that one or more of the disks have a hardware problem, like the one you
> replaced which showed
>>> Device: /dev/sdf [SAT], 35 Currently unreadable (pending) sectors
> Hardware problems would explain the problems you have.
>
> What does smartctl report about your disks, in particular:
> Offline_Uncorrectable
> Current_Pending_Sector
> Reallocated_Sector_Ct

I don't think any of my current disks are showing signs of hardware
problems, looking for the values you suggested:

[root@backend3 gwr]# smartctl -a /dev/sdb | grep -E
"Uncorrectable|Pending|Reallocated"
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0

[root@backend3 gwr]# smartctl -a /dev/sdd | grep -E
"Uncorrectable|Pending|Reallocated"
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       8
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       8

[root@backend3 gwr]# smartctl -a /dev/sde | grep -E
"Uncorrectable|Pending|Reallocated"
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0

[root@backend3 gwr]# smartctl -a /dev/sdf | grep -E
"Uncorrectable|Pending|Reallocated"
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0

I can't get smartctl to tell me anything about /dev/sdc at the moment

> And, is it always ATA 5.00 that is mentioned in syslog? dmesg and the
> "lsdrv" script (google for it) are useful in diagnosing this.

No, all five disks in the array (ATA 5.00 through 9.00) are mentioned
at times in syslog. There doesn't appear to be any rhyme nor reason to
it.


-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
Work: george.rapp -- at -- hp.com (or) george.rapp.ctr -- at -- dfas.mil

A wise and frugal government, which shall restrain men from injuring
one another, which shall leave them otherwise free to regulate their
own pursuits of industry and improvement, and shall not take from the
mouth of labor the bread it has earned. This is the sum of
good government... - Thomas Jefferson, First Inaugural Address
