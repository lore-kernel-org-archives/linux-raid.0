From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: CPU util with and without Raid5
Date: Sun, 20 Sep 2009 12:24:48 -0700
Message-ID: <e9c3a7c20909201224h1cf62b73ie726711f0b484873@mail.gmail.com>
References: <f5d1f90a0909181713x3cb99143raa9e64c27ccac999@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5d1f90a0909181713x3cb99143raa9e64c27ccac999@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 18, 2009 at 5:13 PM, Linux Raid Study
<linuxraid.study@gmail.com> wrote:
> Hello:
>
> I'm seeing some strangeness and want some insight.
>
> Case #1:
> I have 5 disks on my system and each is exported to a iSCSI initiator.
> When I run IOMeter tool, I see CPU util of about 80% of my CPU for
> Seq-Read operations.
>
> Case #2:
> If I bundle these 5 disks as Raid5, the performance is 20% lower as
> compared to above case but the CPU util is only 30% for Seq Read
> operations (as compared to 80% in case #1)
>
> Can someone shed some light on this - why would CPU be lower in #2
> (I'm using 2.6.27 kernel in both cases)?

You are not comparing equivalent configurations.  You are trying to
compare the performance of 5-non-striped data disks in case1 to 4
striped data disks in case2.  Also, asking for opinions on what might
be causing performance differences is almost always the wrong
approach.  Use a profiler, like oprofile in 2.6.27 or perf in recent
kernels, to find the exact answer to where the cpu is spending its
time for a given workload.  There are also tools like blktrace and
seekwatcher that can help analyze block i/o performance.

--
Dan
