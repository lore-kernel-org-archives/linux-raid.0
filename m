From: Tony Germano <tony_germano@hotmail.com>
Subject: RE: Proposal: non-striping RAID4
Date: Thu, 22 May 2008 18:56:25 -0400
Message-ID: <BAY130-W13EE86F049E0D537D5C8B8E1C60@phx.gbl>
References: <BAY130-W418FFF9E3F58536967DDEAE1C60@phx.gbl>
 <A20315AE59B5C34585629E258D76A97C76F854@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C76F854@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


=46irst off, I totally agree with you that standards need to be defined=
=2E I also agree with you that in most situations you would not want to=
 be frequently spinning drives down and up.

That being said, I was explaining particular applications where the dri=
ves are not frequently accessed, and that's where this would be useful.

Western Digital has green drives already in production (albeit without =
standards.) See http://www.wdc.com/en/products/Products.asp?DriveID=3D3=
36

I'm glad I double checked because I almost said these drives have varia=
ble speeds. It looks like the different models spin at different rates =
depending on how many platters they have. However, they do give the sle=
ep/standby power usage as ~3W less than idle. I would imagine that numb=
er would be even larger for "non-green" drives. That can make a huge di=
fference over time and many drives.

Implementing this disk array type would not enforce drive spin down, bu=
t rather allow it where standard raid types do not (within reason.)

I think of this approach as a bunch of independent disks that sacrifice=
 a little write performance for peace of mind knowing that you can rebu=
ild one if necessary. It has limited application, but would be a terrif=
ic option where applicable (online archive that is infrequently accesse=
d.)

Tony Germano


> Subject: RE: Proposal: non-striping RAID4
> Date: Thu, 22 May 2008 17:10:08 -0500
> From: david@santools.com
> To: tony_germano@hotmail.com; linux-raid@vger.kernel.org
>
> I personally have a real problem with sleepy drives. There is no ANSI
> specification, and no drive vendors are making disks (today) that are
> engineered for this. Granted spinning down disks saves power & heat,
> but since disks aren't yet engineered for frequent spin-ups, then the=
re
> are industry-wide concerns about disk life.
>
> Without benefit of an ANSI spec for this mode (and why stop at sleep,
> have several lower-RPM speeds that sacrifice performance for heat/pow=
er
> savings), then I just see too many problems for general use, so it wo=
uld
> have to be limited to an appliance. The appliance vendor would probab=
ly
> have to carefully test & qualify disks, and insure that applications
> won't constantly spin disks up and have problems with 30+ sec timeout=
s
> and such.
>
> I think best next step is to write a bunch of emails to the various A=
NSI
> T10, T11, and T13 committee members and have them work out a spec so =
we
> have rules, and disks that are designed for this purpose.
>
> Undoubtedly there is a need, but without standards it will be a kludg=
e.
>
>
> David lethe
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tony Germano
> Sent: Thursday, May 22, 2008 4:16 PM
> To: linux-raid@vger.kernel.org
> Subject: Re: Proposal: non-striping RAID4
>
>
> I would like to bring this back to the attention of the group (from
> November 2007) since the conversation died off and it looks like a fe=
w
> key features important to me were left out of the discussion... *grin=
*
>
> The original post was regarding "unRAID" developed by
> http://lime-technology.com/
>
> I had an idea in my head, and "unRAID" has features almost identical =
to
> what I was thinking about with the exception of a couple deal breakin=
g
> design decisions. These are due to the proprietary front end, not the
> modified driver.
>
> Bad decision #1) Implementation is for a NAS Appliance. Files are onl=
y
> accessible through a Samba share. (Though this is great for the hoard=
s
> of people that use it as network storage for their windows media cent=
er
> pcs.)
>
> Bad decision #2) Imposed ReiserFS.
>
> Oh yeah, and it's not free in either sense of the word.
>
> The most relevant uses I can think of for this type of array are arch=
ive
> storage and low use media servers. Keeping that in mind...
>
> Good Thing #1)
> "JBOD with parity." Each usable disk is seen separately and has its o=
wn
> filesystem. This allows mixed sized disks and replacing older smaller
> drives with newer larger ones one at a time while utilizing the extra
> capacity right away (after expanding the filesystem.) In the event th=
at
> two or more disks are lost, surviving non-parity disks still have 100=
%
> of their data. (Adding a new disk larger than the parity disk is
> possible, but takes multiple steps of converting it to the new parity
> disk and then adding the old parity disk back to the array as a regul=
ar
> disk... acceptable to me)
>
> Good Thing #2)
> You can spin down idle disks. Since there is no data striping and fil=
e
> systems don't [have to] span drives, reading a file only requires 1 d=
isk
> to be spinning. Writing only requires 1 disk + parity disk. This is a=
n
> important feature to the "GREEN" community. On my mythtv server, I on=
ly
> record a few shows each week. I would have disks in this setup possib=
ly
> not accessed for weeks or even months at a time. They don't need to b=
e
> spinning, and performance is of no importance to me as long as it can
> keep up with writing HD streams.
>
> Hopefully this brings a new perspective to the idea.
>
> Thanks,
> Tony Germano
> _________________________________________________________________
> Keep your kids safer online with Windows Live Family Safety.
> http://www.windowslive.com/family_safety/overview.html?ocid=3DTXT_TAG=
LM_WL
> _Refresh_family_safety_052008--
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

_________________________________________________________________
Make every e-mail and IM count. Join the i=92m Initiative from Microsof=
t.
http://im.live.com/Messenger/IM/Join/Default.aspx?source=3DEML_WL_ Make=
Count--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
