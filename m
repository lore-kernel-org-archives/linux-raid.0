From: Lemur Kryptering <gottail@lemurdude.com>
Subject: Re: Raid 6 - TLER/CCTL/ERC
Date: Wed, 6 Oct 2010 18:11:11 -0500 (CDT)
Message-ID: <3870309.421286406668656.JavaMail.SYSTEM@ninja>
References: <8469417.401286406060921.JavaMail.SYSTEM@ninja>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8469417.401286406060921.JavaMail.SYSTEM@ninja>
Sender: linux-raid-owner@vger.kernel.org
To: stefan huebner <stefan.huebner@stud.tu-ilmenau.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>, philip@turmel.org
List-Id: linux-raid.ids


----- "Stefan /*St0fF*/ H=C3=BCbner" <stefan.huebner@stud.tu-ilmenau.de=
> wrote:

> Hi,
>=20
> it has been discussed many times before on the list ...

My apologies. I browsed a little into the past, but obviously not far e=
nough.

>=20
> Am 06.10.2010 16:12, schrieb Lemur Kryptering:
> > I'll definitely give that a shot when I rebuild this thing.
> >=20
> > In the meantime, is there anything that I can do to convince md not
> to kick the last disk (running on 6 out of 8 disks) when reading a ba=
d
> spot? I've tried setting the array to read-only, but this didn't seem
> to help.
>=20
> You can set the ERC values of your drives.  Then they'll stop
> processing
> their internal error recovery procedure after the timeout and
> continue
> to react.  Without ERC-timeout, the drive tries to correct the error
> on
> its own (not reacting on any requests), mdraid assumes an error after
> a
> while and tries to rewrite the "missing" sector (assembled from the
> other disks).  But the drive will still not react to the write
> request
> as it is still doing its internal recovery procedure.  Now mdraid
> assumes the disk to be bad and kicks it.

That sounds exactly like what I'm seeing in the logs -- the sector init=
ially reported as bad is indeed unreadable via dd. All of the subsequen=
t problems reported in other sectors aren't actually problems when I ch=
eck on them at a later point. Couldn't this be worked around by exposin=
g whatever timeouts there are in mdraid to something that could be adju=
sted in /sys?

>=20
> There's nothing you can do about this viscious circle except either
> enabling ERC or using Raid-Edition disk (which have ERC enabled by
> default).
>=20

I tried connecting the drives directly to my motherboard (my controller=
 didn't seem to want to let me pass the smart commands ERC commands to =
the drives). The ERC commands took, in so far as I was able to read the=
m back with what I set them to. This didn't seem to help much with the =
issues I was having, however.

Lesson-learned on the non-raid edition disks. I would have spent the ex=
tra to avoid all this headache, but am now stuck with these things. I r=
ealize that not fixing the problem at the core (the drives themselves),=
 essentially puts the burden on mdraid (which would be forced to block =
for a ridiculous amount of time waiting for the drive instead of just k=
icking it), however, in my particular case, this sort of delay would no=
t be a cause for concern.

Would someone be able to nudge me in the right direction as far as wher=
e the logic that handles this is located?

> Stefan
> >=20
> > All I'm really trying to do is dd data off of it using
> "conv=3Dsync,noerror". When it hits the unreadable spot, it simply ki=
cks
> the drive from the array, leaving 4/8 disks active, taking down the
> array.
> >=20
> > Again, I don't understand why md would take this action. It would
> make a lot more sense if it simply reported an IO error to whatever
> made the request.
> >=20
> > Peter Zieba
> > 312-285-3794
> >=20
> > ----- Original Message -----
> > From: "Phil Turmel" <philip@turmel.org>
> > To: "Peter Zieba" <pzieba@networkmayhem.com>
> > Cc: linux-raid@vger.kernel.org
> > Sent: Wednesday, October 6, 2010 6:57:58 AM GMT -06:00 US/Canada
> Central
> > Subject: Re: Raid 6 - TLER/CCTL/ERC
> >=20
> > On 10/06/2010 01:51 AM, Peter Zieba wrote:
> >> Hey all,
> >>
> >> I have a question regarding Linux raid and degraded arrays.
> >>
> >> My configuration involves:
> >>  - 8x Samsung HD103UJ 1TB drives (terrible consumer-grade)
> >>  - AOC-USAS-L8i Controller
> >>  - CentOS 5.5 2.6.18-194.11.1.el5xen (64-bit)
> >>  - Each drive has one maximum-sized partition.
> >>  - 8-drives are configured in a raid 6.
> >>
> >> My understanding is that with a raid 6, if a disk cannot return a
> given sector, it should still be possible to get what should have bee=
n
> returned from the first disk, from two other disks. My understanding
> is also that if this is successful, this should be written back to th=
e
> disk that originally failed to read the given sector. I'm assuming
> that's what a message such as this indicates:
> >> Sep 17 04:01:12 doorstop kernel: raid5:md0: read error corrected (=
8
> sectors at 1647989048 on sde1)
> >>
> >> I was hoping to confirm my suspicion on the meaning of that
> message.
> >>
> >> On occasion, I'll also see this:
> >> Oct  1 01:50:53 doorstop kernel: raid5:md0: read error not
> correctable (sector 1647369400 on sdh1).
> >>
> >> This seems to involved the drive being kicked from the array, even
> though the drive is still readable for the most part (save for a few
> sectors).
> >=20
> > [snip /]
> >=20
> > Hi Peter,
> >=20
> > For read errors that aren't permanent (gone after writing to the
> affected sectors), a "repair" action is your friend.  I used to deal
> with occasional kicked-out drives in my arrays until I started runnin=
g
> the following script in a weekly cron job:
> >=20
> > #!/bin/bash
> > #
> > for x in /sys/block/md*/md/sync_action ; do
> >         echo repair >$x
> > done
> >=20
> >=20
> > HTH,
> >=20
> > Phil
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
