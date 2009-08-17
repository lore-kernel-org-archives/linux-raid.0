From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: -z not on RAID0 / MPIO hurdle
Date: Mon, 17 Aug 2009 09:32:56 +0200
Message-ID: <87zl9yvqs7.fsf@frosties.localdomain>
References: <66781b10908121144n1f053b57led29391534614b7@mail.gmail.com>
	<87d4705uxm.fsf@frosties.localdomain>
	<66781b10908140129t4fc0947ek1e6f211758a2e969@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10908140129t4fc0947ek1e6f211758a2e969@mail.gmail.com>
	(mark delfman's message of "Fri, 14 Aug 2009 09:29:39 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mark delfman <markdelfman@googlemail.com> writes:

> Hi Goswin,
>
> I am not sure that this would work well for us... we would have you
> use LVM to create individual block targerts, then use MD to create
> RAIDs and then LVM again to create pools.

Last I tried raid on lvm would mess with the idle I/O
determination. The raid rebuild would cause I/O on the device mapper
and then raid things the user is doing I/O and slows the raid rebuild
down to the minimum speed.

> We would ideally stay to LVM on all our raids (whether 0 / 6 etc). so
> would like to keep it in there...
>
> Does any know if there is a reason -z doesn=E2=80=99t work with RAID0=
 (i mean
> is it designed to not work because of abc reason, or simply its never
> been needed etc)?
>
>
> Thank you for you help
>
>
> Mark D
> On Thu, Aug 13, 2009 at 3:06 AM, Goswin von Brederlow<goswin-v-b@web.=
de> wrote:
>> mark delfman <markdelfman@googlemail.com> writes:
>>
>>> Hi.... I am hopeful that the group could provide me with some advic=
e
>>> regarding limiting the drive size on a RAID0. =C2=A0I know and use =
the =E2=80=93z
>>> option for other raid levels, but this seems to have no effect on
>>> RAID0.
>>>
>>> I am sure many will ask =E2=80=98why bother=E2=80=99 or =E2=80=98us=
e fdisk=E2=80=99 but the problem is:
>>>
>>> We need to have some preserved information on each drive =E2=80=93 =
can be only
>>> a few MB at the end of the drive for example
>>> In the past we have simply used Fdisk to partition, save our data o=
n
>>> Sdx2 and used Mdadm on Sdx1 =C2=A0(which works fine)
>>> But we are looking to move to dual channel SAS drives and use DM MP=
IO
>>>
>>> DM MPIO works fine also, but not on the partitions, only the whole
>>> drive. =C2=A0So when we MDadm DMx it overwrites the SdX2 partition =
etc.
>>>
>>> The answer was that we used the =E2=80=93z and limited the drive si=
ze and
>>> simply used DD to write our data to the end LBA=E2=80=99s....
>>>
>>> But on RAID0 the =E2=80=93z does not seem to function, so I cant th=
ink of a
>>> way around this =EF=81=8C =C2=A0(other than changing the LBA range =
in the drive and
>>> this is restricted I think)
>>>
>>>
>>> Does anyone have any ideas? =C2=A0I appreciate any help
>>
>> LVM and --setphysicalvolumesize on pvcreate?
>>
>> MfG
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Goswin
>>

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
