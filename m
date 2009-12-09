From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [patch 0/1][mdadm] Fix needed to enable RAID volumes on SAS devices
 (version 2).
Date: Wed, 09 Dec 2009 11:12:55 -0700
Message-ID: <4B1FE8A7.9090806@intel.com>
References: <58C655507FA1494D95397652C4416F35CCF61201@irsmsx503.ger.corp.intel.com>	 <20091113193545.GW21495@skl-net.de>	 <1259593933.3178.122.camel@awojcik-linux>	 <20091208163744.7ea0eef9@notabene.brown> <1260380511.27877.25.camel@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1260380511.27877.25.camel@awojcik-linux>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Artur" <artur.wojcik@intel.com>
Cc: Neil Brown <neilb@suse.de>, Andre Noll <maan@systemlinux.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Wojcik, Artur wrote:
>> And I don't like the introduction of a new header file just to store one or 2
>> definitions.  Just put new definitions in mdadm.h  Keep It Simple.
> 
> Sorry but I don't agree. At the moment the source code of mdadm/mdmon is
> not simple.

Adding a new header file for a few definitions does not reduce complexity.

> It's quite complicated. It is hard to analyze how the
> control flows and there's a lot of data and code redundancy in it. In my
> opinion "refactorization" is what this code needs. Splitting code into
> files would be helpful, too.

The current file split is pretty simple and self explanatory.  Each 
major operating mode of mdadm has its own file.

I will say that there are some long functions like Assemble() that could 
use some helper routines to split the major stages.  If only to add 
documentation points and clarify the current working set of parameters. 
  That being said I have only had to touch Assemble.c a handful of 
times, so the cost-benefit ratio of doing this refactoring never became < 1.

If you find some redundant code that would be a good starting point for 
simplification patches.

>> I am perfectly happy with making 'buf' larger as appropriate, even making it
>> PATH_MAX in some cases.
>> I would be happy with more use of asprinf.
>> I would be happy adding checks before certain critical sprintf calls that
>> the result will not exceed the buffer.
> 
> I did not use asprintf function, because it's GNU specific. I had an
> impression that one may try to build mdmdm using non-GNU toolchain.

It is safe to assume that mdadm will always run on a system with glibc, 
uclibc, or an equivalent library that has an asprintf() implementation.

--
Dan
