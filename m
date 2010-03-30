From: Jim Duchek <jim.duchek@gmail.com>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Tue, 30 Mar 2010 12:47:55 -0500
Message-ID: <dead81ad1003301047t6be7b3b4r5bf70ad6317f9d1e@mail.gmail.com>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
	 <5bdc1c8b1003301018j73f2d928x3e2624bac9c1ee94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003301018j73f2d928x3e2624bac9c1ee94@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well it appears that I can absolutely reproduce it 100% of the time by
copying a large (>1 gig) video file and then immediately playing it.
It seems to hit the freeze on just about the same frame every time,
and playing it seems to be necessary (it doesn't freeze if I just do
the copy and go about my business).  Possibly an issue w/disk buffers?
 You're having this happen even if the disk in question is not in an
array?  If so perhaps it's an SATA issue and not a RAID one, and we
should move this discussion accordingly.  I reproduced your steps and
I'm seeing pretty much the same thing, although not quite hitting 100%
wa (although I'm guessing it would if I shut everything else down --
Got a full desktop running).

I'm using a Biostar T41-A7 mobo, Intel Core 2 Quad Q8400 Yorkfield
2.66GHz 4MB L2, and 3 Western Digital Caviar Blue WD5000AAJS drives
and 1 WD5002ABYS.  I note that the 3 older drives claim using ATA-7
and the newer one says ATA-8. Any similarities?

Jim


On 30 March 2010 12:18, Mark Knecht <markknecht@gmail.com> wrote:
> On Tue, Mar 30, 2010 at 10:07 AM, Jim Duchek <jim.duchek@gmail.com> w=
rote:
>> Hi all. =A0Regularly after a large write to the disk (untarring a ve=
ry
>> large file, etc), my RAID5 will 'freeze' for a period of time --
>> perhaps around a minute. =A0My system is completely responsive other=
wise
>> during this time, with the exception of anything that is attempting =
to
>> read or write from the array -- it's as if any file descriptors simp=
ly
>> block. =A0Nothing disk/raid-related is written to the logs during th=
is
>> time. =A0The array is mounted as /home -- so an awful lot of things
>> completely freeze during this time (web browser, any video that is
>> running, etc). =A0The disks don't seem to be actually accessed durin=
g
>> this time (I can't hear them, and the disk access light stays off),
>> and it's not as if it's just reading slowly -- it's not reading at
>> all. =A0 Array performance is completely normal before and after the
>> freeze and simply non-existent during it. =A0The root disk (which is=
 on
>> a seperate disk entirely from the RAID) runs fine during this time, =
as
>> does everything else (network, video card, etc -- as long it doesn't
>> touch the array) -- for example, a Terminal window open is still
>> responsive during the freeze, and 'ls /' would work fine, while 'ls
>> /home' would block until the 'freeze' is over.
>>
>> Some more detailed information on my setup attached. =A0It's pretty
>> vanilla. =A0Unfortunately this started around the time four things
>> happened -- a kernel upgrade to 2.6.32, upgrading my filesystems to
>> ext4, replacing a disk gone bad in the RAID, and a video card change=
=2E
>> I would assume one of these is the culprit, but you know what they s=
ay
>> about 'assume'. =A0I cannot reproduce the problem reliably, but it
>> happens a couple times a day. =A0My questions are these:
>>
>> 1. Is there any way to turn on more detailed logging for the RAID
>> system in the kernel? =A0The wiki or a google search makes no mentio=
n I
>> can find, and mdadm doesn't put anything out during this time.
>> 2. Possibly a problem with the SATA system? =A0My root drive is PATA=
 --
>> my RAID disks are all SATA.
>> 2. Uh, any other ideas? :)
>>
>>
>> Thanks, all.
>>
>> Jim Duchek
>>
>
> I'm seeing a lot of this on a new Intel-based system. I've never run
> into it before.
>
> In my case I can see the delays while looking at top. They correspond
> to 100%wa, as shown here:
>
> top - 02:27:17 up 28 min, =A02 users, =A0load average: 2.76, 1.95, 1.=
30
> Tasks: 125 total, =A0 1 running, 124 sleeping, =A0 0 stopped, =A0 0 z=
ombie
> Cpu0 =A0: =A00.0%us, =A00.0%sy, =A00.0%ni,100.0%id, =A00.0%wa, =A00.0=
%hi, =A00.0%si, =A00.0%st
> Cpu1 =A0: =A00.0%us, =A00.0%sy, =A00.0%ni, =A00.0%id,100.0%wa, =A00.0=
%hi, =A00.0%si, =A00.0%st
> Cpu2 =A0: =A00.0%us, =A00.0%sy, =A00.0%ni,100.0%id, =A00.0%wa, =A00.0=
%hi, =A00.0%si, =A00.0%st
> Cpu3 =A0: =A00.0%us, =A00.0%sy, =A00.0%ni,100.0%id, =A00.0%wa, =A00.0=
%hi, =A00.0%si, =A00.0%st
> Cpu4 =A0: =A00.0%us, =A00.0%sy, =A00.0%ni,100.0%id, =A00.0%wa, =A00.0=
%hi, =A00.0%si, =A00.0%st
> Cpu5 =A0: =A00.0%us, =A00.3%sy, =A00.0%ni, =A00.0%id, 99.7%wa, =A00.0=
%hi, =A00.0%si, =A00.0%st
> Cpu6 =A0: =A00.0%us, =A00.0%sy, =A00.0%ni,100.0%id, =A00.0%wa, =A00.0=
%hi, =A00.0%si, =A00.0%st
> Cpu7 =A0: =A00.0%us, =A00.3%sy, =A00.0%ni, 99.7%id, =A00.0%wa, =A00.0=
%hi, =A00.0%si, =A00.0%st
> Mem: =A0 6107024k total, =A01448676k used, =A04658348k free, =A0 1874=
92k buffers
> Swap: =A04200988k total, =A0 =A0 =A0 =A00k used, =A04200988k free, =A0=
 915900k cached
>
> Like you nothing seems to get written anywhere when this is happening=
,
> and in my case it happens whether I'm using RAID1 or not.
>
> From the command line if I do the following and wait for one of these
> 100%wa events to occur
>
> echo "1" > /proc/sys/vm/block_dump
> ... wait a short while ...
> echo "0" > /proc/sys/vm/block_dump
>
> then grepping dmesg with this command
>
> dmesg | egrep "READ|WRITE|dirtied"
>
> shows the following:
>
>
> flush-8:0(3365): WRITE block 33555792 on sda3
> flush-8:0(3365): WRITE block 33555800 on sda3
> flush-8:0(3365): WRITE block 33701984 on sda3
> flush-8:0(3365): WRITE block 33720128 on sda3
> flush-8:0(3365): WRITE block 33721496 on sda3
> flush-8:0(3365): WRITE block 33816576 on sda3
>
> so something ugly is going on. I have no idea what causes these block=
s
> but they are really messing me up.
>
> Sometimes these events last for minutes. I've not yet discovered if
> it's specific to my drives, my motherboard, the kernel or what.
>
> - Mark
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
