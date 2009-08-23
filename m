From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID5 reshape past 100%
Date: Mon, 24 Aug 2009 09:01:08 +1000 (EST)
Message-ID: <5f8a15e87be7d7d4627dfcb2df8ac019.squirrel@neil.brown.name>
References: <c775b4470908230502o6fa41danf4281ed58f0e82a9@mail.gmail.com>
    <da29e42a203b94c238e8829394b21861.squirrel@neil.brown.name>
    <c775b4470908231539o4a0ab494vc717146d47219062@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c775b4470908231539o4a0ab494vc717146d47219062@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lucian =?iso-8859-1?Q?=C8=98andor?= <lucisandor@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, August 24, 2009 8:39 am, Lucian =C8=98andor wrote:
> Thanks for your reply.
>
> I think I ran into some bug of /proc/mdstat. I am new to all this and
> I have no idea about the right number of blocks, but I am suspecting
> the number of blocks from mdstat is incorrect. (I hope this is it, fo=
r
> the sake of my data.)

Right.  There is a bug in that version of the SuSE kernel (my fault)
which shows incorrect numbers in /proc/mdstat.  The reshape does
work correctly, just the numbers in /proc/mdstat are wrong.
(There should be a new update out that has this bug fixes).

>
> Apparently the reshaping ended a few minutes ago. Here's the situatio=
n
> now:
>
> battlecruiser:~ # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid0] [raid1]
> md2 : active raid5 sde8[6] sdc8[0] sdb8[5] sdf8[4] sda8[3] sdd8[1]
>       4773231360 blocks super 1.0 level 5, 128k chunk, algorithm 0
> [6/6] [UUUUUU]

That all looks good now.


> battlecruiser:~ # zcat /var/log/messages-20090823.gz | grep md
> Aug 22 06:47:47 battlecruiser kernel: md: md2: resync done.
> Aug 22 06:49:10 battlecruiser kernel: JBD: barrier-based sync failed
> on md2 - disabling barriers
> Aug 22 07:02:23 battlecruiser kernel:  CIFS VFS: No response for cmd =
50
> mid 8
> Aug 22 15:52:03 battlecruiser kernel: md: bind<sde8>
> Aug 22 15:53:37 battlecruiser kernel: md: couldn't update array info.=
 -16
> Aug 22 15:54:13 battlecruiser kernel: md: reshape of RAID array md2
> Aug 22 15:54:13 battlecruiser kernel: md: minimum _guaranteed_  speed=
:
> 1000 KB/sec/disk.
> Aug 22 15:54:13 battlecruiser kernel: md: using maximum available idl=
e
> IO bandwidth (but not more than 200000 KB/sec) for reshape.
> Aug 22 15:54:13 battlecruiser kernel: md: using 128k window, over a
> total of 954646272 blocks.
> Aug 23 07:34:59 battlecruiser kernel: md: couldn't update array info.=
 -16
>
> (This last one appears to be the moment when it goes past 100%.)

-16 is EBUSY.  It appears something tried to reshape the array again?
Maybe you tried to repeat the --grow command??  Whatever it was, it was=
n't
allowed to proceed because the array was busy reshaping.
So it is harmless.

>
> I did not restore the internal bitmap (am I allowed? am I required?).
> I am worried about the persistent error regarding the number of
> blocks, the position of the superblock (huge headache, as I have no
> idea, except it could be erroneous), and also about the "failed"
> status (although that seems a known bug).

You are allowed to restore the internal bitmap.  You are only required
to do it if that is what you want.

What "persistent error regarding the number of blocks" are you referrin=
g
to?  Except for the transient problems with mdstat, everything looks
good.

The "fail" is admittedly confusing and will be improved in the next
mdadm.
v1.x metadata keeps a record of devices that have previously been
in the array.  So if a device has ever failed, you can have a record
in the metadata saying that failure happened.  The idea was that if tha=
t
device ever reappears, we remember that is was faulty.  It turned out t=
hat
this wasn't really necessary and is just confusing.  So mdadm will stop
printing that information.


>
> I am pondering whether to extend the file system.

I should be safe to do that.

NeilBrown



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
