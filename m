From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Tue, 30 Mar 2010 10:18:25 -0700
Message-ID: <5bdc1c8b1003301018j73f2d928x3e2624bac9c1ee94@mail.gmail.com>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Duchek <jim.duchek@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 30, 2010 at 10:07 AM, Jim Duchek <jim.duchek@gmail.com> wro=
te:
> Hi all. =C2=A0Regularly after a large write to the disk (untarring a =
very
> large file, etc), my RAID5 will 'freeze' for a period of time --
> perhaps around a minute. =C2=A0My system is completely responsive oth=
erwise
> during this time, with the exception of anything that is attempting t=
o
> read or write from the array -- it's as if any file descriptors simpl=
y
> block. =C2=A0Nothing disk/raid-related is written to the logs during =
this
> time. =C2=A0The array is mounted as /home -- so an awful lot of thing=
s
> completely freeze during this time (web browser, any video that is
> running, etc). =C2=A0The disks don't seem to be actually accessed dur=
ing
> this time (I can't hear them, and the disk access light stays off),
> and it's not as if it's just reading slowly -- it's not reading at
> all. =C2=A0 Array performance is completely normal before and after t=
he
> freeze and simply non-existent during it. =C2=A0The root disk (which =
is on
> a seperate disk entirely from the RAID) runs fine during this time, a=
s
> does everything else (network, video card, etc -- as long it doesn't
> touch the array) -- for example, a Terminal window open is still
> responsive during the freeze, and 'ls /' would work fine, while 'ls
> /home' would block until the 'freeze' is over.
>
> Some more detailed information on my setup attached. =C2=A0It's prett=
y
> vanilla. =C2=A0Unfortunately this started around the time four things
> happened -- a kernel upgrade to 2.6.32, upgrading my filesystems to
> ext4, replacing a disk gone bad in the RAID, and a video card change.
> I would assume one of these is the culprit, but you know what they sa=
y
> about 'assume'. =C2=A0I cannot reproduce the problem reliably, but it
> happens a couple times a day. =C2=A0My questions are these:
>
> 1. Is there any way to turn on more detailed logging for the RAID
> system in the kernel? =C2=A0The wiki or a google search makes no ment=
ion I
> can find, and mdadm doesn't put anything out during this time.
> 2. Possibly a problem with the SATA system? =C2=A0My root drive is PA=
TA --
> my RAID disks are all SATA.
> 2. Uh, any other ideas? :)
>
>
> Thanks, all.
>
> Jim Duchek
>

I'm seeing a lot of this on a new Intel-based system. I've never run
into it before.

In my case I can see the delays while looking at top. They correspond
to 100%wa, as shown here:

top - 02:27:17 up 28 min,  2 users,  load average: 2.76, 1.95, 1.30
Tasks: 125 total,   1 running, 124 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu5  :  0.0%us,  0.3%sy,  0.0%ni,  0.0%id, 99.7%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu7  :  0.0%us,  0.3%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si, =
 0.0%st
Mem:   6107024k total,  1448676k used,  4658348k free,   187492k buffer=
s
Swap:  4200988k total,        0k used,  4200988k free,   915900k cached

Like you nothing seems to get written anywhere when this is happening,
and in my case it happens whether I'm using RAID1 or not.

=46rom the command line if I do the following and wait for one of these
100%wa events to occur

echo "1" > /proc/sys/vm/block_dump
=2E.. wait a short while ...
echo "0" > /proc/sys/vm/block_dump

then grepping dmesg with this command

dmesg | egrep "READ|WRITE|dirtied"

shows the following:


flush-8:0(3365): WRITE block 33555792 on sda3
flush-8:0(3365): WRITE block 33555800 on sda3
flush-8:0(3365): WRITE block 33701984 on sda3
flush-8:0(3365): WRITE block 33720128 on sda3
flush-8:0(3365): WRITE block 33721496 on sda3
flush-8:0(3365): WRITE block 33816576 on sda3

so something ugly is going on. I have no idea what causes these blocks
but they are really messing me up.

Sometimes these events last for minutes. I've not yet discovered if
it's specific to my drives, my motherboard, the kernel or what.

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
