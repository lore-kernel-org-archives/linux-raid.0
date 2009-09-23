From: "Sunpyo Hong" <sunpyo.hong@amac.com>
Subject: RE: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Wed, 23 Sep 2009 09:56:52 -0400
Message-ID: <200909230956588.SM01420@trainer>
References: <70ed7c3e0909221714n1ad1ef80oedf329f17f7dad1c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909221714n1ad1ef80oedf329f17f7dad1c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: 'Robin Hill' <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I actually know the physical order of each HD. I was able to pull them =
out
of the NAS in the order specified in the NAS. (Each HD enclosure was
labeled) In the actual sata ports, this is what the hds are in.

SATA 0: HD1
SATA 1: HD2
SATA 2: HD3
SATA 3: HD4
SATA 4: CD-ROM

I think that linux reads the sata ports like.. 0 =3D sda, 1=3Dsdb.. etc=
=2E So I
assume that HD1 =3D /dev/sda (missing), HD2 =3D /dev/sdb, HD3 =3D /dev/=
sdc, HD4 =3D
/dev/sdd so a create command should look like this:

#mdadm -Cv -level=3D5 --raid-disks=3D4 missing /dev/sdb4 /dev/sdc4 /dev=
/sdd4

This is exactly how I wrote the create command. Again I knew the physic=
al
order of the Raid and put them together in that order. Tell me if I'm d=
oing
something wrong.=20

I'll check out testdisk as well..

Thanks!

-----Original Message-----
=46rom: Majed B. [mailto:majedb@gmail.com]=20
Sent: Tuesday, September 22, 2009 8:14 PM
To: Sunpyo Hong
Cc: Robin Hill; linux-raid@vger.kernel.org
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.

If you are sure that you have created the array with the proper order
of disks (They MUST be in the correct order! Your disks may have
changed their names for some reason -- verify that they are in
order!!) and that you have assembled them properly, I would suggest
you run a tool called "testdisk"

You may have a corrupt filesystem, and testdisk would try to fix it.
Also, to make sure that you have assembled the array in the correct
order, and if the filesystem can't be fixed if it's corrupt, use a
file-recovery tool like foremost or magicrescue and see if they
recover your data.

On Tue, Sep 22, 2009 at 9:42 PM, Sunpyo Hong <sunpyo.hong@amac.com> wro=
te:
> Nothing showed up when I did =A0"sudo lvscan". I'm pretty much stumpe=
d.
>
> -----Original Message-----
> From: Majed B. [mailto:majedb@gmail.com]
> Sent: Tuesday, September 22, 2009 11:24 AM
> To: Sunpyo Hong
> Cc: Robin Hill; linux-raid@vger.kernel.org
> Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
>
> When the array is properly assembled, "sudo lvscan" should show any
> logical volumes. Maybe even without the array assembled.
>
> If nothing shows up, then you don't have an LV configured.
>
> On Tue, Sep 22, 2009 at 6:15 PM, Sunpyo Hong <sunpyo.hong@amac.com> w=
rote:
>>> I am stopping and starting the array. I couldn't mount in both
instances.
>>> The before is the initial assembly array that I force assembled thr=
ough
>>> mdadm -Af. This assembled the raid, but couldn't see an ext3 file
system.
>>
>>>I haven't followed all of this thread, so maybe I missed something,
>>>but have you considered the possibility that there is an LVM config
>>>on the md array, and that the ext3 filesystem is inside a logical
>>>volume?
>>
>>>NeilBrown
>>
>> Hi Neil, I already checked with western digital and its support team=
=2E
What
>> they've told me is that the Raid is an EXT3 and is not LVM config on=
 the
> HD,
>> however knowing WD they might just say that so I'd fork over the cas=
h to
> get
>> my HD recovered for thousands of dollars from them. Is there a way I=
 can
>> check if it's LVM config-ed? Thanks!
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> =A0 =A0 =A0 Majed B.
>
>



--=20
       Majed B.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
