From: Nikhil Kshirsagar <nkshirsa@redhat.com>
Subject: Re: [PATCH] mdadm --detail --scan causes SIGABRT
Date: Fri, 10 Jun 2016 14:12:21 -0400 (EDT)
Message-ID: <11EABA5C-C5DA-4498-B1A0-7E1406B323B0@redhat.com>
References: <575A4018.8050500@redhat.com> <wrfjy46dufxl.fsf@redhat.com> <2F74FF87-7E89-4452-8F90-53923B1B2E80@redhat.com> <wrfj8tydue97.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj8tydue97.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think the sosreport should contain the info of the raid devices even though mdadm crashes so we don't see that output in there , there is proc/mdstat and other raid related info  there. Let me check. 

If nothing else I can ask them for proc/mdstat and mdadm -detail again with the working test binary i sent them. 

-Nikhil.


> On 10-Jun-2016, at 11:18 PM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> 
> Nikhil Kshirsagar <nkshirsa@redhat.com> writes:
>> Hi Jes ,
>> 
>> Would it help to examine the core file ? It's present on the machine
>> and location specified in the bz comments . That's how I saw the data
>> structure that had the issue . Indeed there are other device names
>> where the name does not overflow since they are 32 bytes (which is why
>> I chose this value) or where the name *does* get truncated. However
>> this truncation does not seem to happen for de->d_name which is then
>> copied into dev->sys_name.
>> 
>> As for allocating an appropriate size on the heap instead of a static
>> array it does make sense and I can correct the fix to do that but
>> there are lots of other device names which are static arrays. So which
>> ones do we change ?
> 
> This is the tricky part, sys_name is used in a lot of places in
> different ways.
> 
> Do you know if they have a /dev/oczpcie_11_0_ssd on the system, and if
> they do, how did that device get created?
> 
> Cheers,
> Jes
