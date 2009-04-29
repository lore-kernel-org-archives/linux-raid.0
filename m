From: Luca Berra <bluca@comedia.it>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 09:45:59 +0200
Message-ID: <20090429074559.GA25938@maude.comedia.it>
References: <1240574900.4507.2076.camel@ezra> <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com> <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com> <1240957153.18303.689.camel@ezra> <18935.35747.471257.202356@notabene.brown> <49F78F26.2040909@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49F78F26.2040909@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 28, 2009 at 04:20:06PM -0700, H. Peter Anvin wrote:
>Neil Brown wrote:
>> 
>> That only leaves the question of what happens when a spare is added to
>> the array - how does the grub data get written to the space on the
>> spare.
>> I would rather that grub were responsible for this, than for md to
>> treat that unused space as RAID1.
>> We already have a notification system based on "mdadm --monitor" to
>> process events.  We could possibly plug grub in to that somehow so
>> that it gets told to re-write all it's special blocks every time
>> something significant changes in the array.
>> 
>
>I have multiple issues with this concept (including promoting Grub2, but
>let's not get into that.)

I believe your only issue is promoting grub 2, everything else you say
does not seem to be backed by any other reason.
And, please, quit insulting people, it does no justice to your
intelligence acting like a child.

>For this to be reliable, there is only one sensible configuration, which
>is for /boot to be a RAID-1, which is better handled by -- guess what --
>partitioning systems; and we already have quite a few of those that work
>just fine, thank you.  Otherwise there WILL be configurations -- caused
>by controller failures if nothing else -- that simply will not boot even
>though the system is otherwise functional.  Promoting this kind of stuff
>is criminally stupid.

the very funny thing about this is that the solution you endorse works
in the very same way as the solution the op would like to see
implemented. (well at least a cleaned up version of it, if i read the
word cylinder one more time in AD 2009 i will scream :)

your 'only sensible configuration' puts a hunk of code at the beginning
on the disk, which the machine firmware will run when booting.
this particular piece of code has to be put there by something else than
mdadm.

in the partition table case, this piece of code is very limited and can
only access data on disk if firmware is able to.

the op idea is to put a larger block of code at the beginning of the
disk. We can safely assume that this larger block of code, being at the
_beginning_ of the disk is completely readable by the firmware,
this piece of code would be responsible for reading the raid array,
and loading a linux kernel from it.

It has its plus, while these are worth it vs another scheme is
debateable.

Personally I despise disk partitioning schemes, it is a concept that
should have died long ago, even GPT, while being more sensible than PC
partitions, is of no real use to me.  Ok on ia64 the firmware will read
a GPT partition table and load the EFI from a partition, so yes on
itaniums this would be the way to go, do we really care?

I stumbled upon a lovely failure scenario that shows even your scheme is
fragile at best.
Due to issue i would not dwell on here the first disk was kicked from the
raid1 containing /boot, but it was still very well readable by the bios.
result: i took a while realizing why the hell after upgrading the kernel
the system insisted on booting with the previous kernel ;)

also in your 'one sensible configuration' boot should not only be
raid-1, but it should also be entirely contained in the portion of the
disk accessible via int-13. i have seen distribution installers enforce
the first constraint. not the second.


Regards,
L.


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
