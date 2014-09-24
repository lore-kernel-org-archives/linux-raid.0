From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Moving root to raid, weird raid behaviour
Date: Wed, 24 Sep 2014 21:13:36 +0100
Message-ID: <542325F0.9010306@youngman.org.uk>
References: <54206A9A.8010308@youngman.org.uk> <20140923103704.7116d112@notabene.brown> <542134C3.4090003@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <542134C3.4090003@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've just had a flash of inspiration, and if I'm right it's a pretty
nasty "feature", but surely it would have bitten people before me...

What's the purpose of the array name? And what's going on with multiple
arrays all sharing the same name? This system I'm working on, all three
arrays are called "ashdown:0".

And I've just thoroughly screwed up my dev system - I've lost /home ...
all because I did a --wipe-superblock on a DIFFERENT partition on a
DIFFERENT array!

(Oh, and I've got the boot sequence moaning that sdd and sdd4 have very
similar superblocks - wtf? sdd DOESN'T HAVE a superblock as far as I know!)

But that thing about array names, what I've been doing is creating array
0 (or 1), and when I reboot, it gets changed to 127 or whatever, so the
next array I create is 0 (or 1), etc etc. There seems to be precious
little mention of names, what they do etc, they're treated as an
afterthought. I didn't even realise arrays *had* names, until I noticed
a reference to "mdhome" or something like that. Does that mean I can do
"mdadm --create /dev/mdhome ..." ?

Any light to shed?

(At least I now grok grub2 enough to achieve what I want to, it's just
that it's now making the raid mess worse as grub2 doesn't like it when
arrays disappear under it!)

Cheers,
Wol

On 23/09/14 09:52, Wols Lists wrote:
> On 23/09/14 01:37, NeilBrown wrote:
>> On Mon, 22 Sep 2014 19:29:46 +0100 Wols Lists
>> <antlists@youngman.org.uk> wrote:
>>
>>> I'm not sure if this is weird raid, stupid grub2 or incompetent
>>> newbie, but whatever ... and the system is my development/test
>>> system so if it gets trashed it's no disaster, but I would like
>>> to understand what is going on ...
>>>
>>> Old setup / = sdb2 /var = sdc2 /home = mdX (sdb3, sdc3), mirror
>>>
>>> I added sdd and made a new / = mdY (sdd3, missing) mirror and
>>> added sdd4 to mdX /home = mdX (sdb3 sdc3 sdd4)
>>>
>>> Weirdo one - sdd4 mirrored and synced fine. Then I rebooted ... 
>>> mdX = (sdb3 sdc3 missing) mdZ = (sdd4 missing missing)
>>
>> You probably have something silly in your initrd which is making
>> invalid assumptions. What does /etc/mdadm.conf in your
>> initrd/initramfs contain?
> 
> There shouldn't be anything there. I bombed into a grub2 shell, and
> mdadm.conf appeared to be the empty default. I also used ark to peer
> into the initramfs file and there didn't appear to be an mdadm.conf.
> 
> But I've just had a bit of an uh-oh moment. Bear in mind I have two
> /boot's (mdY/boot and sdb2/boot), and two grubs or more (sda, sdb,
> sdd), I could be barking up a wrong tree. So that's my next step, try
> and *make* *sure* which grub I'm working with! Too many variables...
>>
>>>
>>> wtf?!?!? - oh and both of them share the same uuid. The obvious
>>> (but it shouldn't make any difference?) possibility is that sdb
>>> and sdc are 500Gb, partitioned identically. sdd is 1Tb, so sdd4
>>> is twice the size of the other two.
>>>
>>> The other weirdo is I'm trying to migrate from grub/mbr to
>>> grub2/gpt. Of course that's causing me fun, but I've managed to
>>> get the system booting fine from mdY. Only snag is, when I list
>>> /dev, mdY isn't there! mount shows it as mounted on / but that's
>>> the only place I can find it!
>>
>> udev should create it.  'udevadm trigger' should cause udev to
>> create device files for all devices.  That should  be done as part
>> of the boot sequence. If you run "udevadm trigger" does /dev/mdX
>> get created?
>>
> No errors, no messages, no disk ...
>>
>>>
>>> mdadm v3.2.6 kernel 3.14.14-gentoo
>>>
>>> Any ideas what's going on? I've googled, but everything I find
>>> looks out of date or not relevant.
>>
>> "out of date or not relevant"?? You must have been looking on the 
>> Internet ?!?! :-)
> 
> :-)
> 
> The search results were mostly ubuntu (I run gentoo, but so what),
> grub1, I'm migrating to grub2, and any mention of root/boot got plenty
> of results about not finding root and failing to boot, but absolutely
> nothing about successfully booting off a root that wasn't there! Plus
> they all seemed to be 2010 or earlier ...
>>
>> NeilBrown
>>
> Cheers,
> Wol
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

