From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: Re: md's fail to assemble correctly consistently at system startup -
	mdadm 3.1.2 and Ubuntu 10.04
Date: Mon, 9 Aug 2010 02:00:05 -0700
Message-ID: <AANLkTinxBLbxFoKAt7PHPU_LcC0P8qV3WLV=AYi2ywFS@mail.gmail.com>
References: <AANLkTinQgx1t0eaXuFKLnf+5PBw1AqJpyYfxo-AvZXQf@mail.gmail.com>
	<20100808185806.69085415@notabene>
	<AANLkTi=j5WddChbtjBRCJFc=6XvOmEGL3bZdqJ3NfNeK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=j5WddChbtjBRCJFc=6XvOmEGL3bZdqJ3NfNeK@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

I tested out mdadm 3.1.3 on my configuration and great news! Problem
solved. After 30 reboots, all md's have come up correctly each and
every time. I did not have to use watershed either for the mdadm -i
command. Thanks for your recommendation!

Sincerely,
Tommy

On Sun, Aug 8, 2010 at 7:26 AM, fibreraid@gmail.com <fibreraid@gmail.co=
m> wrote:
> Thank you Neil for the reply and heads-up on 3.1.3. I will test that
> immediately and report back my findings.
>
> One potential issue I noticed is that Ubuntu Lucid's default kernel
> configuration has CONFIG_MD_AUTODETECT enabled. I thought this featur=
e
> might conflict with udev, so I've attempted to disable this by adding
> a parameter to my grub2 bootup: raid=3Dnoautodetect. But I am not sur=
e
> if this is effective. Do you think this kernel setting could also be =
a
> problem source?
>
> Another method I was contemplating to avoid a potential locking issue
> is to have udev's mdadm -i command run with watershed, which should i=
n
> theory serialize it. What do you think?
>
> SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add|change", ENV{ID_FS_TYPE}=3D=3D=
"linux_raid*", \
> =A0 RUN+=3D"watershed -i mdadm /sbin/mdadm --incremental $env{DEVNAME=
}"
>
> Finally, in your view, is it essential that the underlying partitions
> used in the md's be the "Linux raid autodetect" type? My partitions a=
t
> the moment are just plain "Linux".
>
> Anyway, I will test mdadm 3.1.3 right now but I wanted to ask for you=
r
> insight/comments on the above. Thanks!
>
> Best,
> Tommy
>
>
>
> On Sun, Aug 8, 2010 at 1:58 AM, Neil Brown <neilb@suse.de> wrote:
>> On Sat, 7 Aug 2010 18:27:58 -0700
>> "fibreraid@gmail.com" <fibreraid@gmail.com> wrote:
>>
>>> Hi all,
>>>
>>> I am facing a serious issue with md's on my Ubuntu 10.04 64-bit
>>> server. I am using mdadm 3.1.2. The system has 40 drives in it, and
>>> there are 10 md devices, which are a combination of RAID 0, 1, 5, 6=
,
>>> and 10 levels. The drives are connected via LSI SAS adapters in
>>> external SAS JBODs.
>>>
>>> When I boot the system, about 50% of the time, the md's will not co=
me
>>> up correctly. Instead of md0-md9 being active, some or all will be
>>> inactive and there will be new md's like md127, md126, md125, etc.
>>
>> Sounds like a locking problem - udev is calling "mdadm -I" on each d=
evice and
>> might call some in parallel. =A0mdadm needs to serialise things to e=
nsure this
>> sort of confusion doesn't happen.
>>
>> It is possible that this is fixed in the just-released mdadm-3.1.3. =
=A0If you
>> could test and and see if it makes a difference that would help a lo=
t.
>>
>> Thanks,
>> NeilBrown
>>
>>>
>>> Here is the output of /proc/mdstat when all md's come up correctly:
>>>
>>>
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
]
>>> [raid4] [raid10]
>>> md0 : active raid6 sdj1[6] sdk1[7] sdf1[2] sdb1[10] sdg1[3] sdl1[8]=
(S)
>>> sdh1[4] sdm1[9] sde1[1] sdi1[12](S) sdc1[11] sdd1[0]
>>> =A0 =A0 =A0 1146967040 blocks super 1.2 level 6, 128k chunk, algori=
thm 2
>>> [10/10] [UUUUUUUUUU]
>>>
>>> md9 : active raid0 sdao1[1] sdan1[0]
>>> =A0 =A0 =A0 976765440 blocks super 1.2 256k chunks
>>>
>>> md8 : active raid0 sdam1[1] sdal1[0]
>>> =A0 =A0 =A0 976765440 blocks super 1.2 256k chunks
>>>
>>> md7 : active raid0 sdak1[1] sdaj1[0]
>>> =A0 =A0 =A0 976765888 blocks super 1.2 4k chunks
>>>
>>> md6 : active raid0 sdai1[1] sdah1[0]
>>> =A0 =A0 =A0 976765696 blocks super 1.2 128k chunks
>>>
>>> md5 : active raid0 sdag1[1] sdaf1[0]
>>> =A0 =A0 =A0 976765440 blocks super 1.2 256k chunks
>>>
>>> md4 : active raid0 sdae1[1] sdad1[0]
>>> =A0 =A0 =A0 976765888 blocks super 1.2 32k chunks
>>>
>>> md3 : active raid1 sdac1[1] sdab1[0]
>>> =A0 =A0 =A0 195357272 blocks super 1.2 [2/2] [UU]
>>>
>>> md2 : active raid0 sdaa1[0] sdz1[1]
>>> =A0 =A0 =A0 62490672 blocks super 1.2 4k chunks
>>>
>>> md1 : active raid5 sdy1[10] sdx1[9] sdw1[8] sdv1[7] sdu1[6] sdt1[5]
>>> sds1[4] sdr1[3] sdq1[2] sdp1[11](S) sdo1[1] sdn1[0]
>>> =A0 =A0 =A0 2929601120 blocks super 1.2 level 5, 16k chunk, algorit=
hm 2
>>> [11/11] [UUUUUUUUUUU]
>>>
>>> unused devices: <none>
>>>
>>>
>>> -------------------------------------------------------------------=
-------------------------------------------------------
>>>
>>>
>>> Here are several examples of when they do not come up correctly.
>>> Again, I am not making any configuration changes; I just reboot the
>>> system and check /proc/mdstat several minutes after it is fully
>>> booted.
>>>
>>>
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
]
>>> [raid4] [raid10]
>>> md124 : inactive sdam1[1](S)
>>> =A0 =A0 =A0 488382944 blocks super 1.2
>>>
>>> md125 : inactive sdag1[1](S)
>>> =A0 =A0 =A0 488382944 blocks super 1.2
>>>
>>> md7 : active raid0 sdaj1[0] sdak1[1]
>>> =A0 =A0 =A0 976765888 blocks super 1.2 4k chunks
>>>
>>> md126 : inactive sdw1[8](S) sdn1[0](S) sdo1[1](S) sdu1[6](S)
>>> sdq1[2](S) sdx1[9](S)
>>> =A0 =A0 =A0 1757761512 blocks super 1.2
>>>
>>> md9 : active raid0 sdan1[0] sdao1[1]
>>> =A0 =A0 =A0 976765440 blocks super 1.2 256k chunks
>>>
>>> md6 : inactive sdah1[0](S)
>>> =A0 =A0 =A0 488382944 blocks super 1.2
>>>
>>> md4 : inactive sdae1[1](S)
>>> =A0 =A0 =A0 488382944 blocks super 1.2
>>>
>>> md8 : inactive sdal1[0](S)
>>> =A0 =A0 =A0 488382944 blocks super 1.2
>>>
>>> md127 : inactive sdg1[3](S) sdl1[8](S) sdc1[11](S) sdi1[12](S)
>>> sdf1[2](S) sdb1[10](S)
>>> =A0 =A0 =A0 860226027 blocks super 1.2
>>>
>>> md5 : inactive sdaf1[0](S)
>>> =A0 =A0 =A0 488382944 blocks super 1.2
>>>
>>> md1 : inactive sdr1[3](S) sdp1[11](S) sdt1[5](S) sds1[4](S)
>>> sdy1[10](S) sdv1[7](S)
>>> =A0 =A0 =A0 1757761512 blocks super 1.2
>>>
>>> md0 : inactive sde1[1](S) sdh1[4](S) sdm1[9](S) sdj1[6](S) sdd1[0](=
S) sdk1[7](S)
>>> =A0 =A0 =A0 860226027 blocks super 1.2
>>>
>>> md3 : inactive sdab1[0](S)
>>> =A0 =A0 =A0 195357344 blocks super 1.2
>>>
>>> md2 : active raid0 sdaa1[0] sdz1[1]
>>> =A0 =A0 =A0 62490672 blocks super 1.2 4k chunks
>>>
>>> unused devices: <none>
>>>
>>>
>>> -------------------------------------------------------------------=
--------------------------------------------------------
>>>
>>>
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
]
>>> [raid4] [raid10]
>>> md126 : inactive sdaf1[0](S)
>>> =A0 =A0 =A0 488382944 blocks super 1.2
>>>
>>> md127 : inactive sdae1[1](S)
>>> =A0 =A0 =A0 488382944 blocks super 1.2
>>>
>>> md9 : active raid0 sdan1[0] sdao1[1]
>>> =A0 =A0 =A0 976765440 blocks super 1.2 256k chunks
>>>
>>> md7 : active raid0 sdaj1[0] sdak1[1]
>>> =A0 =A0 =A0 976765888 blocks super 1.2 4k chunks
>>>
>>> md4 : inactive sdad1[0](S)
>>> =A0 =A0 =A0 488382944 blocks super 1.2
>>>
>>> md6 : active raid0 sdah1[0] sdai1[1]
>>> =A0 =A0 =A0 976765696 blocks super 1.2 128k chunks
>>>
>>> md8 : active raid0 sdam1[1] sdal1[0]
>>> =A0 =A0 =A0 976765440 blocks super 1.2 256k chunks
>>>
>>> md5 : inactive sdag1[1](S)
>>> =A0 =A0 =A0 488382944 blocks super 1.2
>>>
>>> md0 : active raid6 sdc1[11] sdd1[0] sdh1[4] sdf1[2] sdm1[9] sde1[1]
>>> sdb1[10] sdg1[3] sdl1[8](S) sdj1[6] sdk1[7] sdi1[12](S)
>>> =A0 =A0 =A0 1146967040 blocks super 1.2 level 6, 128k chunk, algori=
thm 2
>>> [10/10] [UUUUUUUUUU]
>>>
>>> md1 : active raid5 sdq1[2] sdy1[10] sdv1[7] sdn1[0] sdt1[5] sdw1[8]
>>> sdp1[11](S) sdr1[3] sdu1[6] sdx1[9] sdo1[1] sds1[4]
>>> =A0 =A0 =A0 2929601120 blocks super 1.2 level 5, 16k chunk, algorit=
hm 2
>>> [11/11] [UUUUUUUUUUU]
>>>
>>> md3 : active raid1 sdac1[1] sdab1[0]
>>> =A0 =A0 =A0 195357272 blocks super 1.2 [2/2] [UU]
>>>
>>> md2 : active raid0 sdz1[1] sdaa1[0]
>>> =A0 =A0 =A0 62490672 blocks super 1.2 4k chunks
>>>
>>> unused devices: <none>
>>>
>>>
>>> -------------------------------------------------------------------=
-------------------------------------------------------
>>>
>>>
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
]
>>> [raid4] [raid10]
>>> md127 : inactive sdab1[0](S)
>>> =A0 =A0 =A0 195357344 blocks super 1.2
>>>
>>> md4 : active raid0 sdad1[0] sdae1[1]
>>> =A0 =A0 =A0 976765888 blocks super 1.2 32k chunks
>>>
>>> md7 : active raid0 sdak1[1] sdaj1[0]
>>> =A0 =A0 =A0 976765888 blocks super 1.2 4k chunks
>>>
>>> md8 : active raid0 sdam1[1] sdal1[0]
>>> =A0 =A0 =A0 976765440 blocks super 1.2 256k chunks
>>>
>>> md6 : active raid0 sdah1[0] sdai1[1]
>>> =A0 =A0 =A0 976765696 blocks super 1.2 128k chunks
>>>
>>> md9 : active raid0 sdao1[1] sdan1[0]
>>> =A0 =A0 =A0 976765440 blocks super 1.2 256k chunks
>>>
>>> md5 : active raid0 sdaf1[0] sdag1[1]
>>> =A0 =A0 =A0 976765440 blocks super 1.2 256k chunks
>>>
>>> md1 : active raid5 sdy1[10] sdv1[7] sdu1[6] sds1[4] sdq1[2]
>>> sdp1[11](S) sdt1[5] sdo1[1] sdx1[9] sdr1[3] sdw1[8] sdn1[0]
>>> =A0 =A0 =A0 2929601120 blocks super 1.2 level 5, 16k chunk, algorit=
hm 2
>>> [11/11] [UUUUUUUUUUU]
>>>
>>> md0 : active raid6 sdl1[8](S) sdd1[0] sdc1[11] sdg1[3] sdk1[7] sde1=
[1]
>>> sdm1[9] sdb1[10] sdi1[12](S) sdh1[4] sdf1[2] sdj1[6]
>>> =A0 =A0 =A0 1146967040 blocks super 1.2 level 6, 128k chunk, algori=
thm 2
>>> [10/10] [UUUUUUUUUU]
>>>
>>> md3 : inactive sdac1[1](S)
>>> =A0 =A0 =A0 195357344 blocks super 1.2
>>>
>>> md2 : active raid0 sdz1[1] sdaa1[0]
>>> =A0 =A0 =A0 62490672 blocks super 1.2 4k chunks
>>>
>>> unused devices: <none>
>>>
>>>
>>>
>>> My mdadm.conf file is as follows:
>>>
>>>
>>> # mdadm.conf
>>> #
>>> # Please refer to mdadm.conf(5) for information about this file.
>>> #
>>>
>>> # by default, scan all partitions (/proc/partitions) for MD superbl=
ocks.
>>> # alternatively, specify devices to scan, using wildcards if desire=
d.
>>> DEVICE partitions
>>>
>>> # auto-create devices with Debian standard permissions
>>> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>>>
>>> # automatically tag new arrays as belonging to the local system
>>> HOMEHOST <system>
>>>
>>> # instruct the monitoring daemon where to send mail alerts
>>> MAILADDR root
>>>
>>> # definitions of existing MD arrays
>>>
>>> # This file was auto-generated on Sun, 13 Jul 2008 20:42:57 -0500
>>> # by mkconf $Id$
>>>
>>>
>>>
>>>
>>> Any insight would be greatly appreciated. This is a big problem as =
it
>>> is now. Thank you very much in advance!
>>>
>>> Best,
>>> -Tommy
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
