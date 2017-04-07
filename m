From: jes.sorensen@gmail.com
Subject: Re: Can we deprecate ioctl(RAID_VERSION)?
Date: Fri, 07 Apr 2017 11:55:51 -0400
Message-ID: <wrfjinmgqkjc.fsf@gmail.com>
References: <wrfjvaqid9ih.fsf@gmail.com> <wrfjr316d6f5.fsf@gmail.com>
        <87h922trit.fsf@notabene.neil.brown.name>
        <070d7f50-c8f0-d5df-89ed-adb8b7582d8a@gmail.com>
        <87vaqhyx4i.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vaqhyx4i.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Fri, 07 Apr 2017 08:44:29 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, kernel-team@fb.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> On Thu, Apr 06 2017, Jes Sorensen wrote:
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
>
> Sounds like a good goal, if approached cautiously (and it does sound
> like you are showing proper caution).
> And I don't think we need the "/configfs" bit.  Configfs is just for
> people who don't understand sysfs ;-)

Glad to hear we're in agreement on this. I definitely want to be
cautious about this. While change is good, we have a responsibility
towards existing users. This isn't a desktop environment after all :)

I am not really tied to sysfs/configfs on this, whoever does that part
of the work gets to show us what he/she works best and explain why.

>> I think it's fair to draw a line in the sand and say that mdadm-4.1+ 
>> will not support kernels older than 2.6.15. I am open to the kernel 
>> version we pick here, but I would like to start deprecating some of the 
>> really old code. I have patches that does this in my tree, but I need to 
>> add a check for kernel version > 2.6.15. I am not aware what SuSE's 
>> enterprise kernel versions look like, but checking RHEL/CentOS RHEL5 was 
>> 2.6.18, while RHEL4 was 2.6.9 - and RHEL4 has been unsupported for quite 
>> a while. At least for RHEL/CentOS 2.6.15 as the line in the sand seems fine.
>
> With my SUSE hat on, I'm happy for new mdadm to not support kernels
> older than 3.0.  Probably even 3.12.

I just pushed the first set of changes into git for this. We no longer
support kernels older than 2.6.15.

If it breaks something else, I am ready to take public blame! If it ends
up biting another distro for a slightly older kernel, we can look at
fixing that up.

>> For the kernel to expose features to userland in the future, I would 
>> prefer to go with a feature-flag style interface exposed via sysfs. That 
>> way a distro could enable one feature, but not the other in their kernel 
>> without having to worry about actual version numbers.
>
> I think there are usually better ways than feature flags.
> If the new feature requires a new file in sysfs, then the existence of
> the file signals the presence of the feature.

That is pretty much how I see feature flags.

Next question since I am wearing my 'what is this old stuff doing' hat.
mdassemble? Does anything still use this? The reason is a lot of the
newer features are explicitly included, and switching to sysfs is
effectively going to kill it, unless it gets a major upgrade.

Cheers,
Jes
