From: David Greaves <david@dgreaves.com>
Subject: Re: questions about softraid limitations
Date: Fri, 16 May 2008 09:36:47 +0100
Message-ID: <482D479F.3040809@dgreaves.com>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs> <482AC2BB.5010602@dgreaves.com> <01be01c8b61a$6e616260$9300a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01be01c8b61a$6e616260$9300a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <djani22@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janos Haar wrote:
>> Firstly, are you aware that Linux SW raid will not understand disks
>> written by hardware raid.
> Yes, i know, but the linux raid is a great tool to try it, and if the
> user know what he is doing, it is safe too. :-)
OK - just checking :)

>> This will not allow md to write superblocks to the disks.
> 
> I think exactly for this steps:
> 
> dd if=/dev/zero of=suberblock.bin bs=64k count=1
> losetup /dev/loop0 superblock.bin
> blockdev --setro /dev/sda
> mdadm --build -l linear /dev/md0 /dev/sda /dev/loop0
> 
> The superblock area is writable.
> And this is enough to try to assemble the array to do the recovery, but
> this step is refused.
Ah, I understand now.
I think you need -n2 to tell mdadm to use 2 devices.

>>> Its OK, but what about building a readonly raid 5 array for recovery
>>> usage only? :-)
>> That's fine. If they are md raid disks. Yours aren't yet since you
>> haven't
>> written the superblocks.
> 
> I only want to help for some people to get back the data.
> I only need to build, not to create.

I think this would be really hard if they are not md arrays since the on-disk
layout is likely to be different. Not something I know how to do.

Typically the first step in recovery is to duplicate the disks using ddrescue
and work on copies of the duplicates where you can overwrite things.
If you have had a hardware failure on the drive then even mounting readonly can
make things worse. (If the mb/controller failed then fair enough - but in that
case it's not a 'recovery', just a simple, 'no-risk(tm)' migration... ?)

Tell us more about the failed system:
* hardware or md raid5  (if hw then you'll need a *lot* of info about on-disk
layout and I personally have no clue how to help - sorry)

If md:
* kernel of original system and new system
* new mdadm version
* what kind of failure occured
* any dmesg data you have
* can you ddrescue the drives and do mdadm --examine /dev/sd<partition> for each
component.

Cheers
David
PS Aplogies if I'm stating things that are obvious to you :)
