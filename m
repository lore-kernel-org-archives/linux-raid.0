From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 20:30:37 +0000
Message-ID: <4FAC256D.2000903@pocock.com.au>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com> <4FABE724.40103@turmel.org> <4FAC0C05.1090007@pocock.com.au> <4FAC1259.6090407@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAC1259.6090407@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/05/12 19:09, Phil Turmel wrote:
> On 05/10/2012 02:42 PM, Daniel Pocock wrote:
>>
>> I think you have to look at the average user's perspective: even most IT
>> people don't want to know everything about what goes on in their drives.
>>  They just expect stuff to work in a manner they consider `sensible'.
>> There is an expectation that if you have RAID you have more safety than
>> without RAID.  The idea that a whole array can go down because of
>> different sectors failing in each drive seems to violate that expectation.
> 
> You absolutely do have more safety, you just might not have as much more
> safety as you think.  Modern distributions try hard to automate much of
> this setup (e.g. Ubuntu tries to set up mdmon for you when you install
> mdadm), but it is not 100%.
> 
> Expectations have also changed in the past few years, too, in opposing
> ways.  One, hard drive capacities have skyrocketed (Yay!), but error
> rate specs have not, so typical users are more likely to encounter UREs.
> 
> Two, Linux has gained much more acceptance from home users building
> media servers and such, with much more exposure to non-enterprise
> components.
> 
> Not to excuse the situation--just to explain it.  Coding in this
> arena is mostly volunteers, too.

I understand what you mean, and some of those issues can't be solved
with some quick fix.

However, the degraded array situation where the user doesn't know what
to do is probably not so bad for a highly technical user who can choose
the correct drive to rescue

In the heat of battle (I've been in various corporate environments when
RAID systems have gone down) there is often tremendous pressure and
emotion.  In that scenario, someone might not have a lot of time to
investigate what is really wrong, and might form the conclusion that all
the drives are completely dead even though it is just a case of a few
bad sectors on each.

>>> Coordinating the drive and the controller timeouts is the *only* way
>>> to avoid the URE kickout scenario.
>>
>> I really think that is something that needs consideration, as a minimum,
>> should md log a warning message if SCTERC is not supported and
>> configured in a satisfactory way?
> 
> This sounds useful.

Maybe it could be checked periodically in case it changes, or in case
not all drives are present at boot time

>>> Changing TLER/ERC when an array becomes degraded for a real hardware
>>> failure is a useful idea. I think I'll look at scripting that.
>>
>> Ok, so I bought an enterprise grade drive, the WD RE4 (2TB) and I'm
>> about to add it in place of the drive that failed.
>>
>> I did a quick check with smartctl:
>>
>> # smartctl -a /dev/sdb -l scterc
>> ....
>> SCT Error Recovery Control:
>>            Read:     70 (7.0 seconds)
>>           Write:     70 (7.0 seconds)
>>
>> so the TLER feature appears to be there.  I haven't tried changing it.
>>
>> For my old Barracuda 7200.12 that is still working, I see this:
>>
>> SCT Error Recovery Control:
>>            Read: Disabled
>>           Write: Disabled
> 
> You should try changing it.  Drives that don't support it won't even
> show you that.
> 
> You can then put "smartctl -l scterc,70,70 /dev/sdX" in /etc/rc.local or
> your distribution's equivalent.

Done - it looks like the drive accepted it

This is what I put in rc.local: I'm hoping that my drives always come up
as sd[ab] of course, are there other ways to do this using disk labels,
or does md have any type of callback/hook scripts (e.g. like ppp-up.d)?

echo -n "smartctl: Trying to enable SCTERC / TLER on main disks..."
/usr/sbin/smartctl -l scterc,70,70 /dev/sda > /dev/null
/usr/sbin/smartctl -l scterc,70,70 /dev/sdb > /dev/null
echo "."

I also have some /sbin/blockdev --setra calls in rc.local, do you have
any suggestions on how that should be optimized for the LVM/md
combination, e.g. I have

Raw partitions: /dev/sd[ab]2 as elements of the RAID1
MD: /dev/md2 as a PV for LVM
LVM: various LVs for different things (e.g. some for photos, some of
compiling large source code projects, very different IO patterns for
each LV)

>> and a diff between the full output for both drives reveals the following:
>>
>> -SCT capabilities:             (0x103f) SCT Status supported.
>> +SCT capabilities:             (0x303f) SCT Status supported.
>>                                         SCT Error Recovery Control
>> supported.
>>                                         SCT Feature Control supported.
>>                                         SCT Data Table supported.
>>
>>
>>
>>
>>>> Here are a few odd things to consider, if you're worried about this topic:
>>>>
>>>> * Using smartctl to increase the ERC timeout on enterprise SATA
>>>> drives, say to 25 seconds, for use with md. I have no idea if this
>>>> will cause the drive to actually try different methods of recovery,
>>>> but it could be a good middle ground.
>>>
>>
>> What are the consequences if I don't do that?  I currently have 7
>> seconds on my new drive.  If md can't read a sector from the drive, will
>> it fail the whole drive?  Will it automatically read the sector from the
>> other drive so the application won't know something bad happened?  Will
>> it automatically try to re-write the sector on the drive that couldn't
>> read it?
> 
> MD fails drives on *write* errors.  It reconstructs from mirrors or
> parity on read errors and writes the result back to the origin drive.

Ok, that is re-assuring

>> Would you know how btrfs behaves in that same scenario - does it try to
>> write out the sector to the drive that failed the read?  Does it also
>> try to write out the sector when a read came in with a bad checksum and
>> it got a good copy from the other drive?
> 
> I haven't experimented with btrfs yet.  It is still marked experimental.

Apparently

a) it may be supported in the next round of major distributions (e.g.
Debian 7 is considering it)
b) the only reason it is still marked experimental (and this is what
I've read, it is not my opinion as I don't know enough about it) is
simply because btrfsck is not fully complete

Also, there is heavy competition from ZFS on FreeBSD, I hear a lot about
people using that combination because of the perceived lateness of btrfs
on Linux - but once again, I don't know how well the ZFS/FreeBSD
combination handles drive hardware, all I know is that ZFS has the
checksum capability (which gives it an edge over any regular RAID1 like
mdraid)

