From: Jessie Evangelista <jessie.evangelista@gmail.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Thu, 15 Mar 2012 20:06:53 +0800
Message-ID: <CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F61803A.60009@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 15, 2012 at 1:38 PM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> On 3/14/2012 7:30 PM, Jessie Evangelista wrote:
>> I want to create a raid10,n2 using 3 1TB SATA drives.
>> I want to create an xfs filesystem on top of it.
>> The filesystem will be used as NFS/Samba storage.
>>
>> mdadm --zero /dev/sdb1 /dev/sdc1 /dev/sdd1
>> mdadm -v --create /dev/md0 --metadata=3D1.2 --assume-clean
>> --level=3Draid10 --chunk 256 --raid-devices=3D3 /dev/sdb1 /dev/sdc1
>> /dev/sdd1
>
> Why 256KB for chunk size?
>
=46or reference, the machine has 16GB memory

I've run some benchmarks with dd trying the different chunks and 256k
seems like the sweetspot.
dd if=3D/dev/zero of=3D/dev/md0 bs=3D64k count=3D655360 oflag=3Ddirect

>
> Looks like you've been reading a very outdated/inaccurate "XFS guide"=
 on
> the web...
>
> What kernel version? =A0This can make a significant difference in XFS
> metadata performance. =A0You should use 2.6.39+ if possible. =A0What
> xfsprogs version?
>

testing was done with ubuntu 10.04LTS with kernel at 2.6.32-33-server
xfsprogs at 3.1.0ubuntu1

>> mkfs -t xfs -l lazy-count=3D1,size=3D128m -f /dev/md0
>
> lazy-count=3D1 is currently the default with recent xfsprogs so no ne=
ed to
> specify it. =A0Why are you manually specifying the size of the intern=
al
> journal log file? =A0This is unnecessary. =A0In fact, unless you have
> profiled your workload and testing shows that alternate XFS settings
> perform better, it is always best to stick with the defaults. =A0They
> exist for a reason, and are well considered.

I'll probably forgo setting the journal log file size. It seemed like
a safe optimization from what I've read.

>> mount -t xfs -o barrier=3D1,logbsize=3D256k,logbufs=3D8,noatime /dev=
/md0
>> /mnt/raid10xfs
>
> Barrier has no value, it's either on or off. =A0XFS mounts with barri=
ers
> enabled by default so remove 'barrier=3D1'. =A0You do not have a RAID=
 card
> with persistent write cache (BBWC), so you should leave barriers
> enabled. =A0Barriers mitigate journal log corruption due to power fai=
lure
> and crashes, which seem seem to be of concern to you.
>
> logbsize=3D256k and logbufs=3D8 are the defaults in recent kernels so=
 no
> need to specify them. =A0Your NFS/Samba workload on 3 slow disks isn'=
t
> sufficient to need that much in memory journal buffer space anyway. =A0=
XFS
> uses relatime which is equivalent to noatime WRT IO reduction
> performance, so don't specify 'noatime'.

I just wanted to be explicit about it so that I know what is set just
in case the defaults change

>
> In fact, it appears you don't need to specify anything in mkfs.xfs or
> fstab, but just use the defaults. =A0Fancy that. =A0And the one thing=
 that
> might actually increase your performance a little bit you didn't
> specify--sunit/swidth. =A0However, since you're using mdraid, mkfs.xf=
s
> will calculate these for you (which is nice as mdraid10 with odd disk
> count can be a tricky calculation). =A0Again, defaults work for a rea=
son.
>
The reason I did not set sunit/swidth is because I read somewhere that
mkfs.xfs will calculate based on mdraid.

>> Will my files be safe even on sudden power loss?
>
> Are you unwilling to purchase a UPS and implement shutdown scripts? =A0=
If
> so you have no business running a server, frankly. =A0Any system will=
 lose
> data due to power loss, it's just a matter of how much based on the
> quantity of inflight writes at the time the juice dies. =A0This probl=
em is
> mostly filesytem independent. =A0Application write behavior does play=
 a
> role. =A0UPS with shutdown scripts, and persistent write cache preven=
t
> this problem. =A0A cheap UPS suitable for this purpose is less money =
than
> a 1TB 7.2k drive, currently.
>

The server is for a non-profit org that I am helping out.
I think a APC Smart-UPS SC 420VA 230V may fit their shoe string budget.

> You say this is an NFS/Samba server. =A0That would imply that multipl=
e
> people or other systems directly rely on it. =A0Implement a good UPS
> solution and eliminate this potential problem.
>
>> Is barrier=3D1 enough?
>> Do i need to disable the write cache?
>> with: hdparm -W0 /dev/sdb /dev/sdc /dev/sdd
>
> Disabling drive write caches does decrease the likelihood of data los=
s.
>
>> I tried it but performance is horrendous.
>
> And this is why you should leave them enabled and use barriers. =A0Be=
tter
> yet, use a RAID card with BBWC and disable the drive caches.

Budget does not allow for RAID card with BBWC
>
>> Am I better of with ext4? Data safety/integrity is the priority and
>> optimization affecting it is not acceptable.
>
> You're better off using a UPS. =A0Filesystem makes little difference =
WRT
> data safety/integrity. =A0All will suffer some damage if you throw a
> grenade at them. =A0So don't throw grenades. =A0Speaking of which, wh=
at is
> your backup/restore procedure/hardware for this array?

nightly backups will be stored on an external USB disk
is xfs going to be prone to more data loss in case the non-redundant
power supply goes out?

>
>> Thanks and any advice/guidance would be appreciated
>
> I'll appreciate your response stating "Yes, I have a UPS and
> tested/working shutdown scripts" or "I'll be implementing a UPS very
> soon." :)

I don't have shutdown scripts yet but will look into it.
Meatware would have to do for now as the server will probably be ON
only when there's people at the office. And yes I will be asking them
to not go into production without a UPS

>
> --
> Stan
>

Thanks for you input Stan.

I just updated the kernel to 3.0.0-16.
Did they take out barrier support in mdraid? or was the implementation
replaced with FUA?
Is there a definitive test to determine if the off the shelf consumer
sata drives honor barrier or cache flush requests?

I think I'd like to go with device cache turned ON and barrier enabled.

Am still torn between ext4 and xfs i.e. which will be safer in this
particular setup.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
