From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID1 On 3 Drives
Date: Mon, 15 Mar 2010 19:05:17 +0300
Message-ID: <70ed7c3e1003150905x63605be5r6ee5874e60069e4b@mail.gmail.com>
References: <4B9C11FB.7040604@gmx.net> <d80f793f1003131518u2bfe77e9k52ef77e3d2c68360@mail.gmail.com>
	<4B9C24B6.7040507@tmr.com> <d80f793f1003150530y1b229f43s1f140f91ab74f3e8@mail.gmail.com>
	<70ed7c3e1003150548v65dce098ud62ddfbcc0747d49@mail.gmail.com>
	<d80f793f1003150747h203aa5c4kc80375f4250f4532@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1003150747h203aa5c4kc80375f4250f4532@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

100-200 MB is good enough for the /boot filesystem.

How much swap to use depends on how much RAM you have and how much RAM
the applications you use demand.
If you have 4GB RAM or more, and most of your usage is about browsing
the Internet, documents, watching videos, ..etc., then 2GB swap is
more than enough even though I think you'll never use it.
In case you ever need more than that, you could also create a
swap-file -- whenever in need, create the file with the size you need
on your array, activate the file as swap and that's it! When done with
it, deactivated and delete the file to reclaim the capacity it once
occupied.

Personally, I keep my /home on its own partition. This guarantees that
whatever system upgrades or distribution installs occur, /home won't
be affected nor touched, and can be seen by multiple Linux distros if
you're into multi-booting.

I have a workstation with 4x 320GB disks with my root filesystem on it
as RAID5. I have to say that it wasn't a good judgment going that way.
One time one of the disks failed and the system refused to boot in
degraded mode, so I had to boot from a CD, resync the array and then
boot normally.
That event got me thinking: Why don't I put / on its own disk and
/home be on the RAID5 array. I could copy / to the array as a backup,
should the OS disk crash; put a new disk, make it bootable, install
grub on it, then using a LiveCD I could boot and access my RAID5 array
and copy the OS files back.

It's OK to have all disks running on the array without a spare. Just
make sure you configure smartd and have it run tests on a daily basis
(short tests) and a weekly basis (long tests) and to have it email you
if problems occur.

=46or RAID performance enhancements, the page seem to have been removed
but a cached version of it is available:
http://74.125.77.132/search?q=3Dcache:5f7lyJQGL78J:www.linuxfoundation.=
org/collaborate/workgroups/linux-raid/performance+http://linux-raid.osd=
l.org/index.php/Performance&cd=3D1&hl=3Den&ct=3Dclnk

=46or RAID benchmarks:
https://turing.phas.ubc.ca/mediawiki/index.php/RAID_benchmarks
http://peterkieser.com/2009/11/27/linux-raid-mdraid-raid6-raid5-benchma=
rks/

I hope these help.

On Mon, Mar 15, 2010 at 5:47 PM, Carlos Mennens <carloswill@gmail.com> =
wrote:
> On Mon, Mar 15, 2010 at 7:48 AM, Majed B. <majedb@gmail.com> wrote:
>> Carlos,
>>
>> Choosing your RAID setup depends on the purpose of your machine. Is =
it
>> a web server, file server, archive, mail, video storage, ...etc.
>
> Basically this is my everyday workstation that I keep everything on.
> It's not hosting Apache or MySQL or anything like that. Just my
> everyday workstation.
>
>> /boot is only used during boot up. Having a spare on stand by or not
>> does not affect performance, except in the case a disk dies; in that
>> case, the hot spare is engaged and becomes an active disk at which t=
he
>> array starts to resync the data to this new disk. During resyncing,
>> performance will be degraded.
>
> Oh, I was wondering why Bill noted previously that a spare would hurt
> performance but based on your info above, this is only if a drive
> fails and then the spare starts to synchronize. I hope that is what
> Bill meant.
>
>> As for your RAID5 question: I think if your usage of the server is
>> write-mostly, you may find it to have better performance with 3 disk=
s
>> rather 4. If it's read-mostly, then 4 disks should perform better.
>>
>> If you have physical access to the machine, try both cases. Setting
>> them up won't take more than 5-10 minutes. Benchmarking wouldn't tak=
e
>> more than 15 minutes in each setup.
>>
>> Remember, there are parameters to fine-tune: NCQ, read-ahead, noatim=
e,
>> nodiratime, chunksize, ...etc.
>
> I do have access to the machine as it's my new Desktop PC I am
> building today at some point. I just wanted to get some expert advise
> on how I should proceed. For now I am going to use all 4 disks with n=
o
> spares.
>
> I just don't know enough about fine tuning and how it could benefit o=
r
> hinder disk performance for my setup so I guess I will omit them unti=
l
> I can understand what to use for what function. If you guys have any
> suggestions for what parameters to use for /boot, /, or swap...please
> feel free to chime in.
>
> Thanks all!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
