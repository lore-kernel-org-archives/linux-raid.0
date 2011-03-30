From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Network-based RAID6
Date: Wed, 30 Mar 2011 11:58:43 -0300
Message-ID: <AANLkTikaTra1okTVMk6+K9GY4a9WgyQSVp8_euoZkMwv@mail.gmail.com>
References: <20110330131157.49fd2521@natsu>
	<AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>
	<20110330144944.3c87185c@natsu>
	<4D933188.30003@hardwarefreak.com>
	<AANLkTikydoHZxYOOT6Lg1bRPTL3_npG5KgTjDgZMzesn@mail.gmail.com>
	<4D934185.9020201@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D934185.9020201@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ocfs is a file system, btrfs too, why using two filesystems? only ocfs
would be used when cluster filesystem
you want more disks per computer using others computers as disks?
or you want more disks in cluster using others computers as nodes of a =
cluster?

first is a single writer filesystem (ext4,reiserfs,xfs)
second is a cluster filesystem (ocfs, and others, check wikipedia for
filesystem lists)

you can use raid1 as block device for filesystem, but i remember that
some cluster filesystems have replication (raid1)

2011/3/30 Miles Fidelman <mfidelman@meetinghouse.net>:
> I wonder how OCFS (or some other distributed file system) would run o=
ver
> btfrs (raid10, no raid6), over AOE or iSCSI block devices.
>
> Roberto Spadim wrote:
>>
>> OCFS with DRBD could work very nice in linux
>> i didn't tested mdadm with ndb in a production enviroment
>> DRBD have brainsplit solutions, since you will run a complex
>> filesystem, i consider using working solutions, DRBD and OCFS is nic=
e
>> yes, mdadm can run under DRBD
>> DRBD =3D raid1 over network
>> OCFS =3D oracle filesystem (cluster filesystem)
>> it works
>>
>> 2011/3/30 Stan Hoeppner<stan@hardwarefreak.com>:
>>
>>>
>>> Roman Mamedov put forth on 3/30/2011 3:49 AM:
>>>
>>>>
>>>> On Wed, 30 Mar 2011 11:20:41 +0400
>>>> CoolCold<coolthecold@gmail.com> =A0wrote:
>>>>
>>>>
>>>>>
>>>>> Looking on your host I think you speak russian, so may be this wi=
ll be
>>>>> somehow helpful for you
>>>>> http://community.livejournal.com/ru_root/2216389.html
>>>>>
>>>>
>>>> Thanks -- I have looked through the websites of some distributed
>>>> filesystems
>>>> (Ceph, GlusterFS, MooseFS etc) and checked this thread too, but fr=
om
>>>> what I
>>>> could find, all filesystems I read about so far are at most capabl=
e of
>>>> RAID0 or
>>>> RAID1-like modes, where fault-tolerance is either not provided, or
>>>> achieved
>>>> only by "all data is replicated across N nodes", which of course d=
ivides
>>>> the
>>>> total usable space by N. I haven't found any FS which would do
>>>> block-level
>>>> replication relying not on dumb copies, but on RAID5/6-like parity
>>>> algorithms
>>>> for fault-tolerance. Maybe I missed something?
>>>>
>>>
>>> You likely won't find any distributed filesystem that performs bloc=
k
>>> level replication over the network, at least not a FOSS one. =A0The=
se are
>>> filesystems, mind you, not distributed block device drivers. =A0If =
they
>>> perform any replication to afford a level of fault tolerance, it wi=
ll be
>>> at the file level, not the block level.
>>>
>>> If you want true block level replication over a network, look into =
DRBD.
>>> =A0However, it is also limited to mirroring.
>>>
>>> --
>>> Stan
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>>
>>
>>
>>
>
>
> --
> In theory, there is no difference between theory and practice.
> In<fnord> =A0practice, there is. =A0 .... Yogi Berra
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
