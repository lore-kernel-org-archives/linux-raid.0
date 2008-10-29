From: "Joe Landman" <joe.landman@gmail.com>
Subject: Re: question on how to (correctly) build an initrd for a root disk on a RAID1
Date: Tue, 28 Oct 2008 21:42:08 -0400
Message-ID: <9f5edc120810281842q7421ea92of6c466693f8f5b7f@mail.gmail.com>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
	 <20081027071613.GA8197@maude.comedia.it>
	 <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
	 <20081028064354.GD7764@percy.comedia.it>
	 <9f5edc120810280520i3ff4855fne765069beeca27e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9f5edc120810280520i3ff4855fne765069beeca27e9@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Update:

On Tue, Oct 28, 2008 at 8:20 AM, Joe Landman <joe.landman@gmail.com> wrote:
> On Tue, Oct 28, 2008 at 2:43 AM, Luca Berra <bluca@comedia.it> wrote:
>> On Mon, Oct 27, 2008 at 08:34:01AM -0400, Joe Landman wrote:

[..]

>>> This implies that /etc/mdadm.conf is in the initrd.  Peeking inside
>>> the default centos one, I can see that this is not true.  Which
>>> implies that it doesn't see /etc/mdadm.conf before it assembles the
>>> array, as the /etc/mdadm.conf is on the array, and not in the initrd
>>> image.
>>>
>>> Is there a way to include the /etc/mdadm.conf into the initrd?
>>
>> mkinitrd should include mdadm and /etc/mdadm.conf if it decides your
>> root is on md
>
> Ok.  This is what I think (e.g. am guessing) is the likely culprit at
> the moment.

In fact, now looking at the generated initrd and the base distro
initrd, neither one has mdadm.conf nor mdadm.

>
> [...]
>
>>>>>  Any suggestions?  More things to read?
>>>>
>>>> is your fstab correct?
>>>
>>> Yes.  Boots fine with older kernel.  fstab doesn't change between the two.
>>
>> i mean, mkinitrd reads /etc/fstab to decide what your root device is,
>> sometimes it fails and creates a wrong initrd
>
> Ok.  I was unaware that it would build an incorrect initrd, I thought
> we could just miss the modules if they weren't explicitly included
> using --with=  or similar.  I have seen that with a number of RAID
> cards, that mkinitrd will not generate a workable initrd (no software
> RAID) as it leaves out the right drivers.  I have been (defensively)
> including RAID card drivers in our initrd builds.

It looks like nash is the thing responsible for raidautorun, and it
doesn't look like this is doing the right thing in the generated
initrd.  Will post the captured trace from nash on downwards soon.
