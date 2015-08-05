From: George Rapp <george.rapp@gmail.com>
Subject: Re: RAID 6 reshape/grow interrupted
Date: Wed, 5 Aug 2015 15:39:26 -0400
Message-ID: <CAF-KpgbSFTgDjwN8Kj0y2U4v81ofY1Lo08bzDei-XiE+1Lx7Ug@mail.gmail.com>
References: <CAF-Kpga0g_y_n_wJFWX84j0Aci_FjXXwNt1VRfMQ1wpcFpBZfg@mail.gmail.com>
 <CAF-KpgZKHG15y+4xPtd4rO3PwAgd8mBySGQTKFUQgAkuGxRgfg@mail.gmail.com> <CAF-KpgaJTfh823O6ESPfDOk=vPfd-fcy5agtfbjpg4o1gYqmnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgaJTfh823O6ESPfDOk=vPfd-fcy5agtfbjpg4o1gYqmnA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Wed, Aug 5, 2015 at 11:59 AM, George Rapp <george.rapp@gmail.com> wrote:
>> On Wed, Aug 5, 2015 at 12:17 AM, George Rapp <george.rapp@gmail.com> wrote:
>>> Hello -
>>>
>>> Fedora 22 user (kernel 4.0.4-303.fc22.i686+PAE) using mdadm - v3.3.2 -
>>> 21st August 2014. (Of course, I don't have a backup ... 8^)
>>>
>>> I had a healthy RAID 6 array, and was trying to grow it from 5
>>> partitions of size 1.8 TB to 6 partitions.
>>>
>>> # mdadm --add /dev/md6 /dev/sdi1
>>>
>>> # mdadm --grow --raid-devices=6 --backup-file=/home/gwr/c/grow_md6.bak /dev/md6
>>>
>>> The second command threw a bunch of SELinux errors (ah, thank you,
>>> SELinux, for always being there to bite me in the ass when I don't
>>> expect it ... 8^) about access to /home/gwr/c/grow_md6.bak. The
>>> reshape operation sat for many minutes at 0% progress, according to
>>> /proc/mdstat. However, the file /home/gwr/c/grow_md6.bak *was*
>>> created; it's about 6MB.
>>
>> Additional data point: the backup file is all zeros, according to an
>> examination with 'od -v'.
>>
>>> In an attempt to kick off the reshape operation, I issued:
>>>
>>> # setenforce 0
>>>
>>> to turn off SELinux enforcement. That didn't help - the reshape sat
>>> still, showing no progress.
>>>
>>> Then I issued:
>>>
>>> # mdadm --stop /dev/md6
>>>
>>> which of course interrupted the reshape operation. It also threw up a
>>> bunch of error messages, which you can find in the dmesg.txt file
>>> found at https://app.box.com/s/3pksam3c7n79anpnzvsrwekzqwtsvlf6 --
>>> look for the words "cut here". It looks like a segfault or other
>>> runtime error:
>>>
>>> [   796.84193] WARNING: CPU: 0 PID: 1444 at mm/backing-dev.c:372
>>> bdi_unregister+0x38/0x50()
>>>
>>> I then tried to restart the grow operation, without SELinux' help, and
>>> got the error message in the subject.
>>>
>>> First, I goofed, and tried the assemble without the backup file:
>>>
>>> # mdadm --assemble /dev/md6 /dev/sdc4 /dev/sdd4 /dev/sdg4 /dev/sdh1 /dev/sdj1
>>>
>>> [ 1966.030411] md: md6 stopped.
>>>
>>> mdadm: Failed to restore critical section for reshape, sorry.
>>>
>>> # mdadm --assemble /dev/md6 /dev/sdc4 /dev/sdd4 /dev/sdg4 /dev/sdh1
>>> /dev/sdj1 --backup-file=/home/gwr/c/grow_md6.bak
>>>
>>> [ 2242.492370] md: md6 stopped.
>>>
>>> mdadm: Failed to restore critical section for reshape, sorry.
>>>
>>> # mdadm --assemble /dev/md6 /dev/sdc4 /dev/sdd4 /dev/sdg4 /dev/sdh1
>>> /dev/sdj1 /dev/sdi1 --backup-file=/home/gwr/c/grow_md6.bak
>>>
>>> [ 2403.741995] md: md6 stopped.
>>>
>>> mdadm: Failed to restore critical section for reshape, sorry.
>>>
>>> I ran an mdadm --examine on all my RAID partitions; the file is at
>>> https://app.box.com/s/9x2n2wc42i1wqzd1ayrt8ta6cyldrr6i. Of note in
>>> that file: the "Reshape pos'n" is 0 on all six drives. I take that to
>>> mean that the reshape operation never really got started.
>>>
>>> Is my next step to add the --invalid-backup switch? If not, what
>>> recommendations might you have to fix this?
>>
>> I tried the --invalid-backup switch this morning without success:
>>
>> md: md6 stopped.
>> md: bind<sdc4>
>> md: bind<sdg4>
>> md: bind<sdh1>
>> md: bind<sdj1>
>> md: bind<sdi1>
>> md: bind<sdd4>
>> md/raid:md6: reshape_position too early for auto-recovery - aborting.
>> md: pers->run() failed ...
>> mdadm: failed to RUN_ARRAY /dev/md6: Invalid argument
>> md: md6 stopped.

First question - is anyone besides me seeing these messages?

I see my postings in the archive at
http://marc.info/?l=linux-raid&r=1&b=201508&w=2 so I assume they're
going out to the distro list, but they have not been sent back to me
nor have I received a reply.

I had a rough time posting the initial message last night due to
Gmail's default use of HTML, which the linux-raid mailer-daemon does
not like -- it only accepted the message when I turned Gmail's "Plain
text mode" on.

Second, I see in http://lwn.net/Articles/565591/ that mdadm 3.3 has an
undocumented option:

"--assemble --update=revert-reshape" can be used to undo a reshape
that has just been started but isn't really wanted

Since I'm on mdadm v3.3.2, I assume I still have that option. Is it
worth trying in my situation?

Thanks for any advice.

George
