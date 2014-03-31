From: bobzer <bobzer@gmail.com>
Subject: Re: strange status raid 5
Date: Mon, 31 Mar 2014 10:35:10 -0400
Message-ID: <CADzS=aqECRsNh_e=0W4wQSnVxa63=pOjDQH29V8ruiJttR5kbw@mail.gmail.com>
References: <CADzS=apR=2D=t47wS9PBHzEdeOS96LE-CbTEBxnd9BLj_=f7jg@mail.gmail.com>
 <alpine.DEB.2.02.1403311627060.747@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1403311627060.747@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry to not be precise enough
here are the command and result i tried:
# mdadm --re-add /dev/md0 /dev/sdb1
mdadm: --re-add for /dev/sdb1 to /dev/md0 is not possible

# mdadm --add /dev/md0 /dev/sdb1
mdadm: /dev/sdb1 reports being an active member for /dev/md0, but a
--re-add fails.
mdadm: not performing --add as that would convert /dev/sdb1 in to a spare.
mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdb1" first.

Also i check my disk and seem ok :
#smartcll -l selftest /dev/sdb1
=== START OF READ SMART DATA SECTION ===
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     14046         -
# 2  Short offline       Completed without error       00%     14041         -


Thanks for helping me

On Mon, Mar 31, 2014 at 10:28 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Mon, 31 Mar 2014, bobzer wrote:
>
>> so there i tried to re-add the disk that doesn't works
>
>
> "Doesn't work" isn't a helpful problem description. Please provide output
> from dmesg when you do this, error message (if any) from CLI, what command
> you tried with, etc.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
