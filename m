From: CoolCold <coolthecold@gmail.com>
Subject: Re: recovering from a controller failure
Date: Mon, 31 May 2010 12:33:24 +0400
Message-ID: <AANLkTike1slvwFahh4hkD2xiFngoBQrzxeoZ5Y8Fu6kK@mail.gmail.com>
References: <AANLkTim0Du0TYrTOQNajPG6IsDnj4aCvjZ3UJtZnweGW@mail.gmail.com>
	<F7.15.03062.2D8E20C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7.15.03062.2D8E20C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 31, 2010 at 2:38 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>
>
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of CoolCold
>> Sent: Sunday, May 30, 2010 8:18 AM
>> To: Leslie Rhorer
>> Cc: Kyler Laird; linux-raid@vger.kernel.org
>> Subject: Re: recovering from a controller failure
>>
>> On Sun, May 30, 2010 at 7:33 AM, Leslie Rhorer <lrhorer@satx.rr.com>
>> wrote:
>> >> On Sun, May 30, 2010 at 09:50:26AM +1200, Richard wrote:
>> >>
>> >> > How about adding entries to your mdadm.conf file containing the=
 UUID
>> >> > of /dev/md0, eg:
>> >> >
>> >> > ARRAY /dev/md8 level=3Draid6 num-devices=3D16
>> >> > UUID=3D38a06a50:ce3fc204:728edfb7:4f4cdd43
>> >> >
>> >> > note this should be all one line.
>> >>
>> >> I'll be happy to do that.
>> >>
>> >> > mdadm -D /dev/md0 should get you the UUID.
>> >>
>> >> =A0 =A0 =A0 root@00144ff2a334:/# mdadm -D /dev/md0
>> >> =A0 =A0 =A0 mdadm: md device /dev/md0 does not appear to be activ=
e.
>> >>
>> >> So...how do I get the UUIDs? =A0I tried blkid and got this.
>> >> =A0 =A0 =A0 http://lairds.us/temp/ucmeng_md/uuids
>> >> Those UUIDs are far from unique.
>> >
>> > =A0 =A0 =A0 =A0After all your drives are visible, of course:
>> >
>> > `mdadm --examine /dev/sd* /dev/hd* > <filename>`
>> > `more <filename>`
>> >
>> > Make note of the array UUID for each drive. =A0When done,
>> >
>> > `mdadm --assemble --assume-clean /dev/mdX /dev/<drive0> /dev/<driv=
e1>
>> > /dev/<drive2> ...etc`
>> >
>> > where <drive0>, <drive1>, etc are all members of the same array UU=
ID.
>> >
>> > =A0 =A0 =A0 =A0Mount the file system, and fsck it. =A0Once everyth=
ing is verified
>> > good,
>> >
>> > `echo repair > /sys/block/mdX/md/sync_action`
>> Taking in account "Events" fields are differing on disks from 1st &
>> 2nd controller, interesting question for me - what will happen on th=
is
>> "repair" ?
>
> =A0 =A0 =A0 =A0Note that should be --force, not --assume-clean. =A0Th=
e --assume-clean
> switch would be used if you re-created the array, not just re-assembl=
ed it.
> Once the array is assembled, the repair function will re-establish th=
e
> redundancy within the array. =A0Any stripes whose data does not match=
 the
> calculated value required to produce the upper layer information are
> re-written.
That's it - as you can see there are 15 drives in raid6 array. Examine
on disks from sda to sdh shows drives active and event count is 0.159,
sdi to sdp events count is 0.168 and show that sd[a-i] are faulty. So
I'm guessing there is no way to know which part of array is "right"
and i guess they are desynced.

>
>> And what this "Events" field really means? I didn't found descriptio=
n
>> in man pages.
>
> =A0 =A0 =A0 =A0I believe a number of things. =A0For one thing, it is =
used to keep
> track of which version of data resides in each drive, whenever an arr=
ay
> event is encountered. =A0The value of the events counter in the membe=
rs of an
> array should not be different by more than 1, or mdadm kicks the driv=
e out
> of the array.
I've thought similar, but interesting - in this situation drives has
event count value like "0.168" and "0.159"...
> I expect it may also be used during forced re-assembly and /
> or during a resync of a RAID1 system to help determine which version =
of a
> stripe is correct.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
