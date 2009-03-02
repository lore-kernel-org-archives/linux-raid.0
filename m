From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: MD software RAID1 vs suspend-to-disk
Date: Mon, 02 Mar 2009 14:40:30 +1100
Message-ID: <87fxhwy4lt.fsf@rimspace.net>
References: <87d4d17hgh.fsf@rimspace.net> <49AB2B65.6070102@anonymous.org.uk>
	<87ocwky86o.fsf@rimspace.net>
	<f28499db7337f052f84784a1967f3758.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"NeilBrown" <neilb@suse.de> writes:
> On Mon, March 2, 2009 1:23 pm, Daniel Pittman wrote:
>> John Robinson <john.robinson@anonymous.org.uk> writes:
>>> On 01/03/2009 08:52, Daniel Pittman wrote:
>>>
>>>> I have a random desktop machine here, running Debian/sid with a
>>>> 2.6.26 Debian kernel.  It has a two disk software RAID1, and
>>>> apparently passes through a suspend/resume cycle correctly, but...

[...]

>> No, that appears to be about suspending and resuming access to the
>> MD device while reconfiguring it; I don't /think/ that is accessed
>> during a system-wide suspend/resume (aka hibernate, or s2disk) cycle.
>>
>> Certainly, it doesn't look like the path is invoked for that from my
>> reading of the code.
>
> Correct, they are completely unrelated.
>
> I have never tried hibernating to an md array, but I think others
> have, though I don't have a lot of specifics.
>
> One observation is that you really don't want resync to start before
> the resume has completed.  For this reason we have the 'start_ro'
> parameter.  Setting that to 1, e.g
>
>   echo 1 > /sys/module/md_mod/parameters/start_ro
>
> will mean that resync will not start until the first write to the
> array.  The initrd should set this before assembling an md array to
> load a resume image from.

Ah.  Debian already do this; see:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=415441
(Actually, since you wrote in that bug thread you already know. :)

Hmmm.  I have swap on LVM on MD, though, and I suspect that LVM writes
to disk when it discovers and activates the volume groups...

Let me try and find out.  Then I can go and be grumpy, but at least
complain to the right people about this. :)

[...]

> It should be that your observed symtpom of "check reports 48800
> mismatches" has nothing to do with hibernate/resume.

OK.

> Presumably you have swap on md/raid1 (as that is where hibenate
> writes).  The nature of swap writeout is that it is entirely possible
> for different data to be written to each device of a raid1 when a page
> is swapped out.
>
> However in that case, the data will never be read back in so the
> apparent corruption is not a problem.

Well, that is a relief, at least.

> I would recommend that you run 'repair' before hibernating, to be sure
> that the array is in-sync.  Then hibenate/resume and see if it is
> still in sync.  I suspect it will be.

That seems reasonable; I will test it.

Regards,
        Daniel

