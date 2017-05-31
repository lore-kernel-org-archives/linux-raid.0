From: Roman Mamedov <rm@romanrm.net>
Subject: Re: RAID10 performance with 20 drives
Date: Wed, 31 May 2017 19:18:50 +0500
Message-ID: <20170531191850.5c7ba616@natsu>
References: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
        <da03d962-2baf-66d9-f037-23de38c1ff50@websitemanagers.com.au>
        <CAGqmV7pdiTKRZY2gnPH0QO7eWLAZVWKZc8tqE1t_rzENVJH8Nw@mail.gmail.com>
        <87cf573c-775c-ee32-1beb-d45702434366@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87cf573c-775c-ee32-1beb-d45702434366@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: CoolCold <coolthecold@gmail.com>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 31 May 2017 10:07:50 -0400
Joe Landman <joe.landman@gmail.com> wrote:

> procs -----------memory---------- ---swap-- -----io---- -system-- 
> ------cpu-----
>   r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
> id wa st
>   3  0      0 130058176   2412 500660    0    0     0     0    3 17  0  
> 2 98  0  0
>   1  0      0 130057352   2412 501012    0    0     0     0 28827 69339  
> 0  3 97  0  0
> 
> 3rd from right is % idle.
> 
> This is 95-98% idle.  Is the rebuild done?

It's a 40-core CPU with one core completely maxed out into 100% use with some
non-multithreaded load from md. Yes, 100% use of one core on a 40-core CPU
will show up as ~97% idle overall. Take a closer look at all the data
presented.

-- 
With respect,
Roman
