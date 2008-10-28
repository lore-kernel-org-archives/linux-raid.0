From: Luca Berra <bluca@comedia.it>
Subject: Re: question on how to (correctly) build an initrd for a root disk on a RAID1
Date: Tue, 28 Oct 2008 07:43:54 +0100
Message-ID: <20081028064354.GD7764@percy.comedia.it>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com> <20081027071613.GA8197@maude.comedia.it> <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 08:34:01AM -0400, Joe Landman wrote:
>> unfortunately the kernel panic is a consequence of a previous error,
>> someone willing to help you would need to know everithing that was
>> spitted between the 'starting red-hat nash' message and the kernel
>> panic.
>
>I looked and this was actually the earliest error.  I will try to
>capture the rest of this and post it for download (it is long).
it should at least spit out the modules it is loading and some of the
action it is doing. comparing this with a running one might help in
understanding what the difference is.

>>> Do I need to create a specialized init script?  Is there an
>>
>> usually no, redhat/centos initrd should be able to boot from a raid1
>
>The baseline provided kernel can.  This is a custom kernel, and I am
>attempting to find the right mkinitrd parameters.  One of the nicer
>things in the Ubuntu/Debian process is that they have the ability to
>add most/all modules in to an initrd.  Somehow this is my current
>thought, that we are missing something critical.
is md modular (CONFIG_MD)?

>>
>>> example of this somewhere?  I did look at the Documentation/md.txt and
>>> tried the
>>>
>>>    md=0,sda1,sdb1 md=1,sda2,sdb2  md=2,sda3,sdb3
>>
>> if you are using the centos kernel, raid is modular and this parameter
>> has no effect.
>> mkinitrd should use your /etc/mdadm.conf to discover how the array
>> should be laid out.
>
>Ok.  This is where it gets interesting.  If the /etc/mdadm.conf is on
>the RAID, you have a bit of a "chicken and egg" problem to deal with
>here.  How does the system find /etc/mdadm.conf to make the RAID when
>/etc/mdadm.conf is on the RAID?
>
>This implies that /etc/mdadm.conf is in the initrd.  Peeking inside
>the default centos one, I can see that this is not true.  Which
>implies that it doesn't see /etc/mdadm.conf before it assembles the
>array, as the /etc/mdadm.conf is on the array, and not in the initrd
>image.
>
>Is there a way to include the /etc/mdadm.conf into the initrd?
mkinitrd should include mdadm and /etc/mdadm.conf if it decides your
root is on md

>>
>>>  kernel boot time option, to no avail.  Persistent superblocks are
>>> on, and the devices have the right partition types.
>>
>> partition types do not matter anymore.
>
>Autoassembly is depracated?
yes
>
>>>  Any suggestions?  More things to read?
>>
>> is your fstab correct?
>
>Yes.  Boots fine with older kernel.  fstab doesn't change between the two.

i mean, mkinitrd reads /etc/fstab to decide what your root device is,
sometimes it fails and creates a wrong initrd

>> is your mdadm.conf correct?
>
>
>Yes.  Boots fine with older kernel.  mdadm.conf doesn't change between the two.
>
>> are you loading the correct drivers for your hd controller?
>
>I believe so:  looked at the list from lsmod and replicated this in
>the mkinitrd.  However, I have seen drivers change markedly release to
>release.  Hence my interest in building an initrd with the maximum
>number of modules (specific to SATA/SCSI)
>
>>
>> mkinitrd is a shell script, if all else fails, run it with sh -x and
>> read the output.
>
>Already done.  Even instrumented the code so I could see what the
>handleraid function was in fact doing.  It looks correct, figures out
>the right modules, and makes sure they are in there.

post it and the content of both initrds on pastebin or such,
you seem to have drawn enough interest that someone will look at it.

>So I am wondering if it is a module load order, or something else like
>that., apart from just a missing module.  Which could be a depmod
>issue.
>

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
