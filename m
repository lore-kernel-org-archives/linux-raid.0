From: Phil Turmel <philip@turmel.org>
Subject: Re: help recovering a software raid5 device
Date: Mon, 28 Jan 2013 08:45:48 -0500
Message-ID: <5106810C.9090406@turmel.org>
References: <CAAXKdzzERB_zzcdPPzuwdL+afFO334X3bck1EvrRV5rFvEEg6Q@mail.gmail.com> <5105D435.8090401@turmel.org> <CAAXKdzzajcx5Ee83fLo1bUbj8hYRh0aqJMcZykNHdgoUtLBkDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAXKdzzajcx5Ee83fLo1bUbj8hYRh0aqJMcZykNHdgoUtLBkDg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Theo Cabrerizo Diem <diem@carpediem.sh>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Theo,

[list restored--please use reply-to-all for kernel.org lists]

On 01/28/2013 05:04 AM, Theo Cabrerizo Diem wrote:
> On 28 January 2013 02:28, Phil Turmel <philip@turmel.org> wrote:
>> On 01/27/2013 08:52 AM, Theo Cabrerizo Diem wrote:
>>> Hello,
> snip
>>>
>>> I did read the wiki, and took a copy of mdadm --examine /dev/sd[ghij]1
>>> before doing anything. I've tried to run :
>>>
>>> mdadm --create --assume-clean --level=5 --chunk 64 --raid-devices=4
>>> /dev/md/stuff1 /dev/sdh1 /dev/sdg1 /dev/sdj1 /dev/sdi1
>>
>> For some reason, people are unwilling to use "--assemble --force", which
>> is made for these situations.
>>
>> This is the correct device order, though, so you aren't toast yet.
>>
> As mentioned by Keith Keller, it is how is instructed on wiki. I had
> the feeling it was not "right" since if you don't add --assume-clean
> it would rebuild it empty, which is fairly dangerous imho ;)
> 
> So before I mess it up even more, the proper command (in my case) would be :
> 
> mdadm --assemble /dev/md/stuff1 --force /dev/sdh1 missing /dev/sdj1 /dev/sdi1
> 
> right ? But I believe the superblock was already overwritten by the
> suggested --create --assume-clean. Should it still be "safe" to try ?

Yes, it is now too late for "--assemble --force".

> I found curious that there's no option to force md to not write
> anything to disks at all, a read-only mechanism for attempting to
> recovery. Any attempt you make potential updates at minimal timestamps
> that could change the original data.

Which is why saving the "--examine" output is so important.

>>> - Should I attempt "mdadm --create" command with just the last 3 good
>>> disks and a "missing" one or should I attempt with all four ?
>>> - Any further suggestions to try to recover it ?
>>
>> I would leave out the disk that failed first (/dev/sdg1, I believe).
>> Presumably there was still some activity on the system?
> 
> Yes, the system was still up but "frozen" since any attempt to access
> the raid device resulted in endless amounts of io error. I've
> attempted an emergency sync and hard booted.

I meant activity between the first failure and the second.

>>> Following my output of mdadm --examine after a reboot (don't know why
>>> the distro detected and assembled the raid with only two devices in a
>>> inactive state)
>>
>> The appended --examine reports show a creation time from 2011, but an
>> update time from just a little while ago.  Did you cancel the "--create"
>> operation(s)?  (That would be good, actually.)
> 
> The examine report was before any attempt of recovery. Unfortunately I
> did run the --create --assume-clean commands as suggested on wiki :(
> ..
> 
>>
>> Please show the saved "--examine" reports, and current "--examine" reports.
> 
> Recent examine report:
> http://pastie.org/5895552
> 
> Saved examine report (same as previously attached):
> http://pastie.org/5895849

In the future, paste these directly into the mail.  Who knows how long
pastie.org will hold on to these, and these mails will be archived
basically forever.

Anyways, they show your problem.

The original reports all have:

>    Data Offset : 2048 sectors

Your recreated array devices have:

>    Data Offset : 262144 sectors

So your copy of mdadm is very new, and has the new defaults for data
offset (leaving more room for a bad block log).  You need to boot with a
slightly older liveCD or other rescue media to get a copy of mdadm that
is about 1 year old.  Re-run the "mdadm --create --assume-clean" with
that version of mdadm.

(The development version of mdadm has command-line syntax to set the
data offset per device, but I don't believe it has been released yet.
If you are comfortable using git and compiling your own utility, that
would be another option.)

>> It wouldn't hurt to also post the "smartctl -x" for each of these drives.
>>
> http://pastie.org/5895385 (sdg - the really broken one - will RMA this
> one after recovering or giving up)

It doesn't appear to be broken.  Just some pending sectors that'll
probably be cleaned up by a wipe, and would have been taken care of with
regular scrubbing.

> http://pastie.org/5895387 (sdh - apparently clean)
> http://pastie.org/5895388 (sdi - apparently clean)
> http://pastie.org/5895389 (sdj - apparently clean)

These do show one critical piece of information that is probably the
only real problem in your system:

> Warning: device does not support SCT Error Recovery Control command

You are using cheap desktop drives that do not support time limits on
error recovery.  They are completely *unsafe* to use "out-of-the-box" in
*any* raid array.

If they did support SCTERC, you could use a boot script to set short
timeouts.  Since they don't, your only option is a boot script to set
very long timeouts in the linux driver for each disk.

> #! /bin/bash
> # Place in rc.local or wherever your distro expects boot-time scripts
> #
> for x in sdg sdh sdi sdj
> do
>     echo 180 >/sys/block/$x/device/timeout
> done

Long timeouts can have negative consequences for services that might be
using the array, but you have no choice.  If you don't do this, any
unrecoverable read error will cause the offending disk to be kicked out
instead of fixed.  (Including errors found during scrubbing.)

> Thanks for stepping up for help :). I did use pastie.org to avoid a
> wall of text. some of those outputs are even bigger what is allowed by
> pastie. Let me know if you would prefer next outputs to be inline.

Yes.

HTH,

Phil
