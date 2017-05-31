From: Joe Landman <joe.landman@gmail.com>
Subject: Re: RAID10 performance with 20 drives
Date: Wed, 31 May 2017 10:07:50 -0400
Message-ID: <87cf573c-775c-ee32-1beb-d45702434366@gmail.com>
References: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
 <da03d962-2baf-66d9-f037-23de38c1ff50@websitemanagers.com.au>
 <CAGqmV7pdiTKRZY2gnPH0QO7eWLAZVWKZc8tqE1t_rzENVJH8Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7pdiTKRZY2gnPH0QO7eWLAZVWKZc8tqE1t_rzENVJH8Nw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>, Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 05/31/2017 09:57 AM, CoolCold wrote:
> Hello!
> thanks for reply, tried to answer questions below and with help of
> gists of github as Gmail forcibly cuts the lines.
> https://gist.github.com/CoolCold/676a6f9df0478c1c2d8ac8f3e6f9e22a
>
> Added vmstat output as well.

[...]

> Sorry, but doesn't that say 95.3% idle?
> No, it says 95.3 busy with right formatting, see
> https://gist.github.com/CoolCold/676a6f9df0478c1c2d8ac8f3e6f9e22a#file-gistfile1-txt-L49

Look at the vmstat output.

procs -----------memory---------- ---swap-- -----io---- -system-- 
------cpu-----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa st
  3  0      0 130058176   2412 500660    0    0     0     0    3 17  0  
2 98  0  0
  1  0      0 130057352   2412 501012    0    0     0     0 28827 69339  
0  3 97  0  0

3rd from right is % idle.

This is 95-98% idle.  Is the rebuild done?

You are doing about 29k interrupts per second, and about 69k context 
switches.  Not heavily loaded unless this is a lower end CPU/desktop system.

This isn't a CPU bound problem if the rebuild is not done.  You'll need 
to look elsewhere.

How are the drives connected to the HBA, which HBA are you using, and 
what driver for it?  Also

     cat /proc/interrupts | grep $HBA

for the driver named $HBA (your driver),  could be helpful here ... 
though ... since you aren't throwing interrupts hard, chances are that 
this won't be as useful.

Likely ... lower end SATA HBA or motherboard based unit, or a weak expander.

--
e: joe.landman@gmail.com
t: @hpcjoe
w: https://scalability.org
g: https://github.com/joelandman


