From: Randy Terbush <randy@terbush.org>
Subject: Re: (Re: Questions regarding startup of imsm container)
Date: Tue, 23 Mar 2010 08:49:09 -0600
Message-ID: <7db987b31003230749u711351fev2a6896a3d6e923b5@mail.gmail.com>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
	<20100323080419.GA9374@maude.comedia.it> <7db987b31003230558l5993817fwb283c66bbf3633e9@mail.gmail.com>
	<7db987b31003230733n127ed0e2u35bbd1de3cb57733@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7db987b31003230733n127ed0e2u35bbd1de3cb57733@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So more info:

I can assemble this array as expected by doing the following:

mdadm -A /dev/md0 /dev/sd[bcde]
mdadm -I /dev/md0

I get:
# ls -l /dev/md/
total 0
lrwxrwxrwx 1 root root 6 Mar 23 08:40 0 -> ../md0
lrwxrwxrwx 1 root root 8 Mar 23 08:40 127 -> ../md127
lrwxrwxrwx 1 root root 8 Mar 23 08:40 Volume0_0 -> ../md127

and:
# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md127 : active raid5 sdb[3] sdc[2] sdd[1] sde[0]
      2930280448 blocks super external:/md0/0 level 5, 64k chunk,
algorithm 0 [4/4] [UUUU]
      [=3D>...................]  resync =3D  5.8% (57270016/976760320)
finish=3D179.4min speed=3D85376K/sec

md0 : inactive sdb[3](S) sde[2](S) sdd[1](S) sdc[0](S)
      9028 blocks super external:imsm

unused devices: <none>

Not clear if this will force a resync every start...


On Tue, Mar 23, 2010 at 8:33 AM, Randy Terbush <randy@terbush.org> wrot=
e:
> To follow-up this startup challenge... here is what I am getting.
>
> mdraid is being started with mdadm -As
>
> I have the following in mdadm.conf
>
> HOMEHOST Volume0
> #DEVICE /dev/sd[bcde]
> AUTO +imsm hifi:0 -all
> ARRAY metadata=3Dimsm UUID=3D30223250:76fd248b:50280919:0836b7f0
> ARRAY /dev/md/Volume0 container=3D30223250:76fd248b:50280919:0836b7f0
> member=3D0 UUID=3D8a4ae452:da1e7832:70ecf895:eb58229c
>
> The following devices are being created.
>
> # ls -l /dev/md/
> total 0
> lrwxrwxrwx 1 root root 6 Mar 23 08:10 0 -> ../md0
> lrwxrwxrwx 1 root root 8 Mar 23 08:17 126 -> ../md126
> lrwxrwxrwx 1 root root 8 Mar 23 08:17 127 -> ../md127
> lrwxrwxrwx 1 root root 8 Mar 23 08:17 imsm0 -> ../md127
> lrwxrwxrwx 1 root root 8 Mar 23 08:17 Volume0 -> ../md126
>
> cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md126 : active raid5 sdb[3] sdc[2] sdd[1] sde[0]
> =A0 =A0 =A02930280448 blocks super external:/md127/0 level 5, 64k chu=
nk,
> algorithm 0 [4/4] [UUUU]
> =A0 =A0 =A0[>....................] =A0resync =3D =A01.8% (18285824/97=
6760320)
> finish=3D182.6min speed=3D87464K/sec
>
> md127 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
> =A0 =A0 =A09028 blocks super external:imsm
>
> unused devices: <none>
>
> So the container device is getting moved from md0 to md127. Not sure =
why.
>
> And would sure like to have a write-intent bitmap active to avoid thi=
s
> resync issue which seems to be happening way too frequently.
>
>
> On Tue, Mar 23, 2010 at 6:58 AM, Randy Terbush <randy@terbush.org> wr=
ote:
>> On Tue, Mar 23, 2010 at 2:04 AM, Luca Berra <bluca@comedia.it> wrote=
:
>>>> # mdadm --version
>>>> mdadm - v3.1.2 - 10th March 2010
>>>>
>>>> # mdadm -Es
>>>> ARRAY metadata=3Dimsm UUID=3D30223250:76fd248b:50280919:0836b7f0
>>>> ARRAY /dev/md/Volume0 container=3D30223250:76fd248b:50280919:0836b=
7f0
>>>> member=3D0 UUID=3D8a4ae452:da1e7832:70ecf895:eb58229c
>>>>
>>>> # ls -l /dev/md/
>>>> total 0
>>>> lrwxrwxrwx 1 root root 6 Mar 22 20:54 0 -> ../md0
>>>> lrwxrwxrwx 1 root root 8 Mar 22 20:54 127 -> ../md127
>>>> lrwxrwxrwx 1 root root 8 Mar 22 20:54 Volume0_0 -> ../md127
>>>>
>>>> As you can see, the name for the link in /dev/md does not agree wi=
th
>>>> the name that the Examine is coming up with.
>>>
>>> please read mdadm.conf manpage, under the section "HOMEHOST"
>>
>> If I understand this correctly, I think there still may be a problem
>> as I am not clear on how I could have set the homehost in the metada=
ta
>> for this imsm array. The Volume0 is provided by imsm and is configur=
ed
>> in the option ROM.
>>
>> The underlying question here is should the ARRAY entry in mdadm.conf
>> be changed to reflect the on disk name of the device, or is the
>> startup process munging that entry when it processes mdadm.conf to
>> strip the _0.
>>
>> I'll try setting HOMEHOST <ignore> to see if I am getting expected r=
esults.
>>
>> I seem to have some problems with startup still as I have the
>> following entry where the container is now md127. Was md0 when
>> originally created.
>>
>> # cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [r=
aid4]
>> md126 : active raid5 sdb[3] sdc[2] sdd[1] sde[0]
>> =A0 =A0 =A02930280448 blocks super external:/md127/0 level 5, 64k ch=
unk,
>> algorithm 0 [4/4] [UUUU]
>>
>> md127 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
>> =A0 =A0 =A09028 blocks super external:imsm
>>
>> unused devices: <none>
>>
>> I am also running into a problem where fsck will crash during boot o=
n
>> the ext4 filesystems that this array contains. No problem running fs=
ck
>> after the boot process has completed so have not seemed to find the
>> magic with order of startup for this device.
>>
>>
>>>
>>>> Is it better to just forgo the ARRAY statements and go with an AUT=
O +imsm?
>>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
