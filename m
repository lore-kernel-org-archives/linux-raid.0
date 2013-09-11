From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Wed, 11 Sep 2013 09:40:56 +0200
Message-ID: <CAC9WiBiRWN4sZ=nd2R3+XqxMD2X=d9F6JtDGpXaNX1jtOFMB4w@mail.gmail.com>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
	<20130904160832.3627bcb8@notabene.brown>
	<CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>
	<20130905121123.27968f9f@notabene.brown>
	<CAC9WiBiHcS126iFv91250d83sMrBYmRbvoqYAEhjJWjb2p5J3A@mail.gmail.com>
	<CAC9WiBgRiu_YL1TpzD4dtLXv=LiA-RERn+C6Q+i=P_WTNdw3+w@mail.gmail.com>
	<20130911093518.794bbb21@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130911093518.794bbb21@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Wed, Sep 11, 2013 at 1:35 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 5 Sep 2013 11:03:14 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
>
>> On Thu, Sep 5, 2013 at 9:04 AM, Francis Moreau <francis.moro@gmail.com> wrote:
>> > Hi Neil,
>> >
>> > On Thu, Sep 5, 2013 at 4:11 AM, NeilBrown <neilb@suse.de> wrote:
>> >> On Wed, 4 Sep 2013 09:36:27 +0200 Francis Moreau <francis.moro@gmail.com>
>> >> wrote:
>> >
>> > [...]
>> >
>> >>> no arrays to monitor... exiting
>> >>>
>> >>
>> >> The line
>> >>
>> >>> mdmon: ddf_open_new: subarray 0 doesn't exist
>> >>
>> >> is the problem.  mdmon read the metadata from the array but didn't find
>> >> subarray '0' in there even though the previous mdmon clearly did:
>> >>
>> >>> ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b1n
>> >>
>> >> This suggests that even though it succeeded in reading the metadata (it would
>> >> have printed
>> >>     Cannot load metadata for md127
>> >> and exited if it had), the metadata is somehow inconsistent.
>> >>
>> >> Could you trying running each mdmon under strace:
>> >>   strace -f -o /tmp/str-1 ./mddmon --takeover --all
>> >>
>> >> and attach the two /tmp/str-? files?
>> >
>> > This is weird: if I'm doing that the first strace process is put in a
>> > uninterruptible state at some point:
>> >
>> > # ps aux | grep dmon
>> > root      2297  0.1  0.0   4468   736 tty1     D+   08:39   0:00
>> > strace -f -o /tmp/str-1 ./mdmon --takeover --all
>> > root      2301  0.6  1.0  15156 11056 ?        SLsl 08:39   0:00
>> > ./mdmon --takeover md127
>> >
>> > Starting the second straced mdmon does the same result, and the system
>> > is becoming unusable as soon as it tries to write something to the
>> > disk/raid I guess.
>> >
>> > Note that /tmp on my system is not a tmpfs filesystem but is part of /
>> > which is ext4.
>> >
>> > I gave a second shot but this time I tried to put the strace output
>> > files on /dev/shm which is a tmpfs FS. This time I didn't have the
>> > issue describes above where strace is put in D state. But since after
>> > the second run of mdmon, there was no running mdmon process anymore,
>> > it was hard to retrieve the 2 strace output files.
>> >
>> > Anyways I'm attaching the 2 files now.
>> >
>> >>
>> >> Also what is the difference between
>> >>   mdadm --examine /dev/sda
>> >> and
>> >>   mdadm --examine /dev/sdb
>> >> ??
>> >>
>> >
>> > After the system finish booting:
>> >
>> > # diff -u sda sdb
>> > --- sda 2013-09-05 09:00:59.554291764 +0200
>> > +++ sdb 2013-09-05 09:01:01.634279757 +0200
>> > @@ -1,4 +1,4 @@
>> > -/dev/sda:
>> > +/dev/sdb:
>> >            Magic : de11de11
>> >          Version : 01.02.00
>> >  Controller GUID : 4C696E75:782D4D44:20202020:2020206C:6F63616C:686F7374
>> > @@ -23,5 +23,5 @@
>> >
>> >   Physical Disks : 2
>> >        Number    RefNo      Size       Device      Type/State
>> > -         0    2cf00056   2064384K /dev/sda        active/Online
>> > -         1    b342fbdc   2064384K                 active/Online
>> > +         0    2cf00056   2064384K                 active/Online
>> > +         1    b342fbdc   2064384K /dev/sdb        active/Online
>> >
>> > After starting the first mdmon process:
>> >
>> > # mdadm --examine /dev/sda >sda
>> > Segmentation fault
>> >
>> > It looks like mdadm is running an infinite loop or something before segfaulting.
>> >
>>
>> I don't know if that can help but it seems to start failing here:
>>
>> # strace ./mdadm --examine /dev/sda
>> ...
>> write(2, "mdmon: Failed to load secondary "..., 55) = 55
>
> The problem is actually a bit earlier, but it does relate to the secondary
> copy of the metadata.
>
> The first sign of trouble is that str-1 has
>
> 2435  lseek(6, 2131022336, SEEK_SET)    = 2131022336
> 2435  read(6, "3333\27.3#Linux-MD20130828\3143\177\"\373\324\32\230"..., 512) = 512
>
> while str-2 has
>
> 2452  lseek(6, 2131022336, SEEK_SET)    = 2131022336
> 2452  read(6, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 512) = 512
>
>  From the same offset, very different data is read.
>
> Presumably it was written by the first write of mdmon.
> Looking further in str-1 we find:
>
> 2436  lseek(7, 18446744073709551104, SEEK_SET) = -1 EINVAL (Invalid argument)
> 2436  write(7, "\336\21\336\21~.\307}Linux-MD\336\255\276\357\0\0\0\0?O\2672\2045b="..., 512) = 512
>
> That is a big number:  "-1 << 9".

Thanks for the details.

>
> mdmon is trying to write the secondary metadata but there isn't any.
> So it writes it in the wrong place and makes a mess.

Hm, it remembers me a warning I saw which was:

mdmon: Failed to load secondary DDF header on /dev/block/8:0

it might be related.

>
> I think this patch will help.  The last hunk in particular should make the
> difference.
>
> Please let me know if it fixes the problem.
>

Yes it fixes the problem.

I had to adjust the patch to make it compile by using be64_to_cpu()
where needed.

Thanks !
-- 
Francis
