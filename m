From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: Can we deprecate ioctl(RAID_VERSION)?
Date: Thu, 6 Apr 2017 14:14:20 -0400
Message-ID: <0cdb9fe9-0eea-3c4f-af93-5894d04d680f@gmail.com>
References: <wrfjvaqid9ih.fsf@gmail.com> <wrfjr316d6f5.fsf@gmail.com>
 <87h922trit.fsf@notabene.neil.brown.name>
 <070d7f50-c8f0-d5df-89ed-adb8b7582d8a@gmail.com>
 <7f1cdca1-2781-d6da-265c-6a51061b3da0@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7f1cdca1-2781-d6da-265c-6a51061b3da0@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, kernel-team@fb.com
List-Id: linux-raid.ids

On 04/06/2017 02:10 PM, Coly Li wrote:
> On 2017/4/6 下午11:31, Jes Sorensen wrote:
>> Neil,
>>
>> I see, thanks for explaining.
>>
>> The goal is to eventually get out of the ioctl() business and get to a
>> state where we can do everything via sysfs/configfs. Right now we have a
>> big mix between ioctl and sysfs where neither interface does everything.
>> The recent issues with PPL (I think it was) showed that we had to add
>> more ioctl support because the interfaces needed to do it for sysfs
>> weren't quite there. My long term goal is to get that situation improved
>> so we can avoid adding anymore ioctl interfaces and eventually allow for
>> distros to build mdadm with ioctl support disabled. We had a discussion
>> at LSF/MM in Boston about this (Hannes, Shaohua, Song, and myself).
>>
>> Reading the code I found it confusing that it was so tied to the patch
>> level, but didn't do anything with the version numbers. At least
>> intuitively if I bumped the version number, I would reset the patchlevel
>> which would break things.
>>
>> I think it's fair to draw a line in the sand and say that mdadm-4.1+
>> will not support kernels older than 2.6.15. I am open to the kernel
>> version we pick here, but I would like to start deprecating some of the
>> really old code. I have patches that does this in my tree, but I need to
>> add a check for kernel version > 2.6.15. I am not aware what SuSE's
>> enterprise kernel versions look like, but checking RHEL/CentOS RHEL5 was
>> 2.6.18, while RHEL4 was 2.6.9 - and RHEL4 has been unsupported for quite
>> a while. At least for RHEL/CentOS 2.6.15 as the line in the sand seems
>> fine.
>>
>> For the kernel to expose features to userland in the future, I would
>> prefer to go with a feature-flag style interface exposed via sysfs. That
>> way a distro could enable one feature, but not the other in their kernel
>> without having to worry about actual version numbers.
>
> BTW, I'd like to take on the kernel side stuffs.
> IMHO, it would be better that we also set a timeline, after the
> timeline, we should add new interface via configfs, and keep all legancy
> ioctl implementation before this timeline.
>
> Coly

A volunteer! A volunteer!

I don't think we need to set a firm timeline for removing code from the 
kernel at this point. What we can do is implement the new interfaces via 
sysfs/configfs, and then make ioctl support a config option. Down the 
line it will be evident if/when we can rip out the old code, but I see 
that being years away.

Cheers,
Jes

