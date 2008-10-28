From: "Joe Landman" <joe.landman@gmail.com>
Subject: Re: question on how to (correctly) build an initrd for a root disk on a RAID1
Date: Tue, 28 Oct 2008 08:20:05 -0400
Message-ID: <9f5edc120810280520i3ff4855fne765069beeca27e9@mail.gmail.com>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
	 <20081027071613.GA8197@maude.comedia.it>
	 <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
	 <20081028064354.GD7764@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081028064354.GD7764@percy.comedia.it>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 28, 2008 at 2:43 AM, Luca Berra <bluca@comedia.it> wrote:
> On Mon, Oct 27, 2008 at 08:34:01AM -0400, Joe Landman wrote:
>>>
>>> unfortunately the kernel panic is a consequence of a previous error,
>>> someone willing to help you would need to know everithing that was
>>> spitted between the 'starting red-hat nash' message and the kernel
>>> panic.
>>
>> I looked and this was actually the earliest error.  I will try to
>> capture the rest of this and post it for download (it is long).
>
> it should at least spit out the modules it is loading and some of the
> action it is doing. comparing this with a running one might help in
> understanding what the difference is.

Ok, this makes sense.  Will bring this to a slightly different machine
today and see if we can continue work (put on hold for a few days)

>
>>>> Do I need to create a specialized init script?  Is there an
>>>
>>> usually no, redhat/centos initrd should be able to boot from a raid1
>>
>> The baseline provided kernel can.  This is a custom kernel, and I am
>> attempting to find the right mkinitrd parameters.  One of the nicer
>> things in the Ubuntu/Debian process is that they have the ability to
>> add most/all modules in to an initrd.  Somehow this is my current
>> thought, that we are missing something critical.
>
> is md modular (CONFIG_MD)?

Yes.  Same .config for a different kernel exhibiting the same problem.

grep CONFIG_MD .config
CONFIG_MD=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
# CONFIG_MDIO_BITBANG is not set

[...]

>> This implies that /etc/mdadm.conf is in the initrd.  Peeking inside
>> the default centos one, I can see that this is not true.  Which
>> implies that it doesn't see /etc/mdadm.conf before it assembles the
>> array, as the /etc/mdadm.conf is on the array, and not in the initrd
>> image.
>>
>> Is there a way to include the /etc/mdadm.conf into the initrd?
>
> mkinitrd should include mdadm and /etc/mdadm.conf if it decides your
> root is on md

Ok.  This is what I think (e.g. am guessing) is the likely culprit at
the moment.

[...]

>>>>  Any suggestions?  More things to read?
>>>
>>> is your fstab correct?
>>
>> Yes.  Boots fine with older kernel.  fstab doesn't change between the two.
>
> i mean, mkinitrd reads /etc/fstab to decide what your root device is,
> sometimes it fails and creates a wrong initrd

Ok.  I was unaware that it would build an incorrect initrd, I thought
we could just miss the modules if they weren't explicitly included
using --with=  or similar.  I have seen that with a number of RAID
cards, that mkinitrd will not generate a workable initrd (no software
RAID) as it leaves out the right drivers.  I have been (defensively)
including RAID card drivers in our initrd builds.

>
>>> is your mdadm.conf correct?
>>
>>
>> Yes.  Boots fine with older kernel.  mdadm.conf doesn't change between the
>> two.
>>
>>> are you loading the correct drivers for your hd controller?
>>
>> I believe so:  looked at the list from lsmod and replicated this in
>> the mkinitrd.  However, I have seen drivers change markedly release to
>> release.  Hence my interest in building an initrd with the maximum
>> number of modules (specific to SATA/SCSI)
>>
>>>
>>> mkinitrd is a shell script, if all else fails, run it with sh -x and
>>> read the output.
>>
>> Already done.  Even instrumented the code so I could see what the
>> handleraid function was in fact doing.  It looks correct, figures out
>> the right modules, and makes sure they are in there.
>
> post it and the content of both initrds on pastebin or such,
> you seem to have drawn enough interest that someone will look at it.

Ok, will bring the disks to a slightly different machine so I can do
the serial port captures.  Will post when I can (later
today/tomorrow).

Thanks for all the suggestions and guidance!

Joe
