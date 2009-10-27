From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: md software raid
Date: Tue, 27 Oct 2009 16:52:23 -0400
Message-ID: <4AE75D87.60708@tmr.com>
References: <26023091.post@talk.nabble.com> <20091023093820.GA7613@cthulhu.home.robinhill.me.uk> <000601ca56ee$f7a4d360$e6ee7a20$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000601ca56ee$f7a4d360$e6ee7a20$@com>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Docherty <idiandocherty@googlemail.com>
Cc: 'Robin Hill' <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ian Docherty wrote:
>   
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Robin Hill
>> Sent: 23 October 2009 10:38
>> To: linux-raid@vger.kernel.org
>> Subject: Re: md software raid
>>
>> On Fri Oct 23, 2009 at 02:11:09AM -0700, ian.d wrote:
>>
>>     
>>> hello
>>>
>>> As a newbie to Linux kernel etc.
>>>
>>> How do you tell which version of md software raid is included in a
>>> specific kernel version?
>>> Is there a command to run which will return this info?
>>> Is it possible to install different versions of md in different
>>>       
>> kernels?
>>     
>> There's two separate components to Linux software RAID - the md code in
>> the kernel, and the mdadm application which interfaces with it.  I very
>> much doubt the kernel code is versioned at all, other than by the
>> kernel version (or GIT version).  The mdadm application is versioned,
>> and you can get the installed version by running 'mdadm -V'.
>>
>> Some of the mdadm functionality will only work with newer kernel
>> versions, but you should be able to run any version with any kernel
>> (within reason anyway) and make use of the core functionality.  There
>> may be some exceptions here, but they should be detailed in the release
>> notes for specific versions.
>>
>> As for changing the md version in the kernel - it may be possible, but
>> generally there's a lot of work involved in back/forward porting code
>> between kernel versions (because of changes to core structures, etc).
>>
>> Is there any particular reason you're asking this (e.g. needing to use
>> some of the latest functionality with an older kernel)?  You may get a
>> more definitive answer if you have a specific case.
>>     
>
> Thanks this info was very helpful.
>
> The reason I asked was because I have been following a thread re MD-XFS 50%
> write performance issue with different kernel releases and as performance is
> important to me  I was thinking it might be better for me to use an older
> kernel (2.6.28.4) but keeping md,mdadm functionality up to date 
>   

That's certainly a valid point, if you are stuck using xfs by preference 
or requirement. I have seen claims that 2.6.32 will be better, but I 
have no intention of testing it, having parted company with xfs a while ago.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

