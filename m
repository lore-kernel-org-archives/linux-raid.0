From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Tue, 19 Nov 2013 12:08:56 -0800
Message-ID: <CAGRSmLvjph4GrD_6hXcPa9RiM-uW0034roHMsZQ=m8QNMzvpJA@mail.gmail.com>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
	<528BBFEB.7050202@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528BBFEB.7050202@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

and don't forget it's not 100% of the time, it's about 50% of the time
3.3 gives a problem so not sure if it's an uninitialized variable or
something like that?   3.2.6 works 100% of the time.  And again on
RAID0 - RAID1 haven't seen a problem.

On Tue, Nov 19, 2013 at 11:45 AM, Martin Wilck <mwilck@arcor.de> wrote:
> On 11/19/2013 01:01 AM, NeilBrown wrote:
>> On Mon, 18 Nov 2013 15:13:58 -0800 "David F." <df7729@gmail.com> wrote:
>>
>>
>>> output of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.2.6):
>> ...
>>> mdadm: no RAID superblock on /dev/sdc2
>>
>>
>>
>>>
>>> output1 of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.3 -
>>> note using /dev/sdc2, not /dev/sdc):
>> .....
>>> mdadm: /dev/sdc2 is identified as a member of /dev/md/imsm0, slot -1.
>>
>> So there is the problem.  mdadm 3.2.6 sees no RAID superblock on sdc2, while
>> mdadm 3.3 does (but should not).
>>
>>
>> However that code hasn't changed!
>>
>> load_super_imsm() still starts with:
>>
>>
>>       if (test_partition(fd))
>>               /* IMSM not allowed on partitions */
>>               return 1;
>
> Well not quite - you changed that code in commit b31df436 "intel,ddf:
> don't require partitions when ignore_hw_compat is set". Maybe there's
> something wrong with that ignore_hw_compat logic?
>
> In the strace I don't see indication of test_partition having been
> called, that's another hint in that direction.
>
> Martin
>
>>
>>
>> and test_partition hasn't changed since it was written in April 2010 for
>> mdadm 3.1.3.
>>
>> So I'm quite perplexed.
>>
>> Is your mdadm-3.3 compiled from source or provided by a distro?
>>
>> Can you run the "mdadm --assemble" under strace and post the result?
>>
>>   strace -o /tmp/some-file mdadm --assemble --scan ......
>>
>> Thanks,
>> NeilBrown
>
