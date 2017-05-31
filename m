From: Joe Landman <joe.landman@gmail.com>
Subject: Re: RAID10 performance with 20 drives
Date: Wed, 31 May 2017 10:35:53 -0400
Message-ID: <dd4aa54f-8409-8da5-6ff9-56305ccd2ada@gmail.com>
References: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
 <da03d962-2baf-66d9-f037-23de38c1ff50@websitemanagers.com.au>
 <CAGqmV7pdiTKRZY2gnPH0QO7eWLAZVWKZc8tqE1t_rzENVJH8Nw@mail.gmail.com>
 <87cf573c-775c-ee32-1beb-d45702434366@gmail.com>
 <20170531191850.5c7ba616@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170531191850.5c7ba616@natsu>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 05/31/2017 10:18 AM, Roman Mamedov wrote:
> On Wed, 31 May 2017 10:07:50 -0400
> Joe Landman <joe.landman@gmail.com> wrote:
>
>> procs -----------memory---------- ---swap-- -----io---- -system--
>> ------cpu-----
>>    r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
>> id wa st
>>    3  0      0 130058176   2412 500660    0    0     0     0    3 17  0
>> 2 98  0  0
>>    1  0      0 130057352   2412 501012    0    0     0     0 28827 69339
>> 0  3 97  0  0
>>
>> 3rd from right is % idle.
>>
>> This is 95-98% idle.  Is the rebuild done?
> It's a 40-core CPU with one core completely maxed out into 100% use with some
> non-multithreaded load from md. Yes, 100% use of one core on a 40-core CPU
> will show up as ~97% idle overall. Take a closer look at all the data
> presented.
>

Hmmm... Methinks thou dost protesteth to much.

The system is effectively idle apart from 1 CPU.  20 physical, 40 with 
SMT.  1 fully loaded CPU in either context is between 2.5 and 5% 
loaded.  In no scenario that I've seen, would I (or anyone else) call 
this "loaded".

Moreover ... and this is the important part ... the interrupt rate and 
CSW rate was low.  Which means that the CPU is not struggling with 
overhead of handling the "calculations" which for RAID10 are ... well 
... trivial (effectively buffer copies).

This means a single CPU was "loaded", but in the context of bio 
submissions that were queued and being waited for.  Not because of 
calculations.  That is, if you understand how linux actually calculates 
load, you understand that IOs queued play a (significant) factor.  You 
would see queued reads in the vmstat line, as well as blocked reads.  
This is one of the reasons I asked for this output ... vmstat is 
suprisingly simple, and incredibly informative.  You can get similar 
information from dstat, or glances -t 1 if you have that installed.

So, the information we have is

1) interrupts are not wildly inappropriate
2) context switches are also reasonable
3) CPU (a single core) is not doing much calculation

Whats left.

1) driver
2) hardware (HBA and/or expander)
3) disk configuration (WCE,RCD)
4) ncq
5) read-ahead  (what does 'blockdev --getra /dev/sd*' report?)

In a Holmesian manner, we simple remove the impossible (based upon our 
observation), and what remains, no matter how improbably, is likely a 
factor.

The system has very low actual computational load, interrupt and context 
switch load.   So  ... its not ... loaded.  Then what comes next?  The 
list I gave.

Feel free to suggest other things.

--
Joe Landman
e: joe.landman@gmail.com
t: @hpcjoe
w: https://scalability.org
g: https://github.com/joelandman






