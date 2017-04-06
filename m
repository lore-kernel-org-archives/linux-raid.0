From: Coly Li <colyli@suse.de>
Subject: Re: Can we deprecate ioctl(RAID_VERSION)?
Date: Fri, 7 Apr 2017 02:10:38 +0800
Message-ID: <7f1cdca1-2781-d6da-265c-6a51061b3da0@suse.de>
References: <wrfjvaqid9ih.fsf@gmail.com> <wrfjr316d6f5.fsf@gmail.com>
 <87h922trit.fsf@notabene.neil.brown.name>
 <070d7f50-c8f0-d5df-89ed-adb8b7582d8a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <070d7f50-c8f0-d5df-89ed-adb8b7582d8a@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, kernel-team@fb.com
List-Id: linux-raid.ids

On 2017/4/6 下午11:31, Jes Sorensen wrote:
> On 04/05/2017 06:32 PM, NeilBrown wrote:
>> On Thu, Apr 06 2017, jes.sorensen@gmail.com wrote:
>>
>>> jes.sorensen@gmail.com writes:
>>>> Hi Neil,
>>>>
>>>> Looking through the code in mdadm, I noticed a number of cases calling
>>>> ioctl(RAID_VERSION). At first I had it confused with metadata version,
>>>> but it looks like RAID_VERSION will always return 90000 if it's a valid
>>>> raid device.
>>>>
>>>> In the cases we want to confirm the fd is a valid raid array,
>>>> ioctl(GET_ARRAY_INFO) should do, or sysfs_read(GET_VERSION).
>>>>
>>>> Am I missing something obvious here, or do you see any reason for
>>>> leaving this around?
>>>
>>> Sorry the above is wrong, it will always return 900, not 90000. Some of
>>> the code that stood out is in util.c:
>>>
>>> int md_get_version(int fd)
>>> {
>>>         struct stat stb;
>>>         mdu_version_t vers;
>>>
>>>         if (fstat(fd, &stb)<0)
>>>                 return -1;
>>>         if ((S_IFMT&stb.st_mode) != S_IFBLK)
>>>                 return -1;
>>>
>>>         if (ioctl(fd, RAID_VERSION, &vers) == 0)
>>>                 return  (vers.major*10000) + (vers.minor*100) +
>>> vers.patchlevel;
>>>         if (errno == EACCES)
>>>                 return -1;
>>>         if (major(stb.st_rdev) == MD_MAJOR)
>>>                 return (3600);
>>>         return -1;
>>> }
>>>
>>> ....
>>>
>>> int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
>>> {
>>>         /* Initialise kernel's knowledge of array.
>>>          * This varies between externally managed arrays
>>>          * and older kernels
>>>          */
>>>         int vers = md_get_version(mdfd);
>>>         int rv;
>>>
>>> #ifndef MDASSEMBLE
>>>         if (st->ss->external)
>>>                 rv = sysfs_set_array(info, vers);
>>>         else
>>> #endif
>>>                 if ((vers % 100) >= 1) { /* can use different
>>> versions */
>>>                 mdu_array_info_t inf;
>>>                 memset(&inf, 0, sizeof(inf));
>>>                 inf.major_version = info->array.major_version;
>>>                 inf.minor_version = info->array.minor_version;
>>>                 rv = ioctl(mdfd, SET_ARRAY_INFO, &inf);
>>>         } else
>>>                 rv = ioctl(mdfd, SET_ARRAY_INFO, NULL);
>>>         return rv;
>>> }
>>>
>>> This has been around since at least 2008, the current code came in
>>> f35f25259279573c6274e2783536c0b0a399bdd4, but it looks like even the
>>> prior code made the same assumptions.
>>>
>>> In either case, the above 'if ((vers % 100) >= 1)' will always trigger
>>> since the kernel does #define MD_PATCHLEVEL_VERSION 3
>>>
>>> It's not like we have been updating MD_PATCHLEVEL_VERSION for a
>>> while. Was the code meant to be looking at the superblock minor version?
>>> I've been staring at this for a while now, so please beat me over the
>>> head if I missed something blatantly obvious.
>>>
>>> Jes
>>
>> It is hard to get versioning right...
>>
>> The version returned by the RAID_VERSION ioctl is meant to reflect the
>> capabilities of the implementation.  We could use the kernel version
>> number for that (and sometimes do), but as distro's often backport
>> features, that isn't always reliable.
>>
>> I've incremented the MD_PATCHLEVEL_VERSION when a change is made that
>> cannot easily be detected from user-space.  As you note, we are up to
>> three.  The last change was in 2.6.15.
>> I've never contemplated changing the other two numbers that RAID_VERSION
>> return.  They don't seem to mean anything useful.
>>
>> What exactly do you mean by "deprecate" the ioctl?
>> If you remove the code in mdadm that calls it, mdadm will not work
>> correctly on kernels older than 2.6.15, and it will be harder to
>> and an future capability that is not easily visible from user space.
>> If you remove the code in the kernel that handles it, you'll break
>> mdadm.
> 
> Neil,
> 
> I see, thanks for explaining.
> 
> The goal is to eventually get out of the ioctl() business and get to a
> state where we can do everything via sysfs/configfs. Right now we have a
> big mix between ioctl and sysfs where neither interface does everything.
> The recent issues with PPL (I think it was) showed that we had to add
> more ioctl support because the interfaces needed to do it for sysfs
> weren't quite there. My long term goal is to get that situation improved
> so we can avoid adding anymore ioctl interfaces and eventually allow for
> distros to build mdadm with ioctl support disabled. We had a discussion
> at LSF/MM in Boston about this (Hannes, Shaohua, Song, and myself).
> 
> Reading the code I found it confusing that it was so tied to the patch
> level, but didn't do anything with the version numbers. At least
> intuitively if I bumped the version number, I would reset the patchlevel
> which would break things.
> 
> I think it's fair to draw a line in the sand and say that mdadm-4.1+
> will not support kernels older than 2.6.15. I am open to the kernel
> version we pick here, but I would like to start deprecating some of the
> really old code. I have patches that does this in my tree, but I need to
> add a check for kernel version > 2.6.15. I am not aware what SuSE's
> enterprise kernel versions look like, but checking RHEL/CentOS RHEL5 was
> 2.6.18, while RHEL4 was 2.6.9 - and RHEL4 has been unsupported for quite
> a while. At least for RHEL/CentOS 2.6.15 as the line in the sand seems
> fine.
> 
> For the kernel to expose features to userland in the future, I would
> prefer to go with a feature-flag style interface exposed via sysfs. That
> way a distro could enable one feature, but not the other in their kernel
> without having to worry about actual version numbers.

BTW, I'd like to take on the kernel side stuffs.
IMHO, it would be better that we also set a timeline, after the
timeline, we should add new interface via configfs, and keep all legancy
ioctl implementation before this timeline.

Coly

