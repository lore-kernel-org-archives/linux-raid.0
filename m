From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: need a little help rebuilding a raid 10
Date: Tue, 6 Dec 2011 09:11:24 -0500
Message-ID: <CAGpXXZKWB7qpRtWK7GuohuF-OOuAGQ_tSODCnLCouS+Z-SWZDA@mail.gmail.com>
References: <CAGpXXZKdbs+Y3qNHnVmFGB3sKE5R7viRajrVM+udUqoDgsA0yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGpXXZKdbs+Y3qNHnVmFGB3sKE5R7viRajrVM+udUqoDgsA0yg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hmm...

My rebuild failed.  At first glance I had both a failed drive and a fai=
led slot?

What I don't understand is I have I/O errors in /var/log/messages from
when the rebuild failed over night.

But this morning, hdparm --read-sector is reading the "bad" sectors fin=
e.

I already tried replacing the drive and the replacement drive also
reported media errors during the rebuild, that's why I came to believe
I had a bad slot.

Now I have non-repeatable media errors.

fyi: I have the problem drive connected via eSata now, so it's a
different controller totally than where it was when the failure first
occurred.

Any thoughts?

Thanks
Greg

On Mon, Dec 5, 2011 at 9:05 PM, Greg Freemyer <greg.freemyer@gmail.com>=
 wrote:
> All,
>
> I have a raid10 that failed recently due to a failed drive slot. =A0T=
he
> drive is good from what I can tell. =A0In theory it is rebuilding now=
=2E
>
> 1) Once the current recovery process finishes, are there any commands
> I can (should) issue to make sure the array is consistent. =A0I'm afr=
aid
> my mirror halves won't really be in sync.
>
> 2) If I want to pause the recovery and do some production real, can I
> do that? =A0How?
>
> =3D=3D details
>
> Not sure why but each of the members dropped one by one until the
> raid10 went offline.
>
> I likely did something wrong by now, but I currently have it in this =
state:
>
> md127 : active raid10 sdb5[4] sda5[0] sdc3[5] sdd3[2]
> =A0 =A0 =A0923517952 blocks super 1.2 512K chunks 2 near-copies [4/3]=
 [UUU_]
> =A0 =A0 =A0[>....................] =A0recovery =3D =A00.8% (4117760/4=
61758976)
> finish=3D1373.3min speed=3D5553K/sec
>
> (it used to be md2. =A0No idea where md127 came from. =A0There are on=
ly 4
> md's on the machine.)
>
> It's currently providing a usable volume I think. =A0I just rebooted =
the
> machine and the filesystem looks good at first glance.
>
> The recovery looks very slow to me, but maybe I still have hardware i=
ssues.
>
> The first 2 members forming a raid 1 immediately after being told
> makes since to me. =A0I don't understand how the 3rd member got sync'=
ed
> up so fast. =A0It seemed to be instantaneous and I don't think it was=
 in
> sync.
>
> Originally it was a raid10 with
> sda5 mirrored to sdb5
> sdc3 mirrored to sdd3
> (or so I believe)
>
> Immediately after the failure I had nothing, so I did:
> # mdadm --stop /dev/md2
>
> # mdadm --create /dev/md2 -v --assume-clean --level=3Draid10
> --raid-devices=3D4 /dev/sda5 missing /dev/sdd3 missing
>
> (or similar, my sdX names have been changing as this event progresses=
=2E
> These names are based on what I see in mdstat.)
>
> I ran that way for a day, which is why I really don't think either of
> the missing mirror halves should have immediately sync'ed.
>
> Anyway, I have a backup but I prefer not to use it if it can be
> avoided. =A0(the machine is in sporadic production, for an hour or tw=
o
> at a time, and going offline for a day to recreate it from scratch
> does not sound like fun.)
>
>
> Thanks
> Greg
> --
> Greg Freemyer
> Head of EDD Tape Extraction and Processing team
> Litigation Triage Solutions Specialist
> http://www.linkedin.com/in/gregfreemyer
> CNN/TruTV Aired Forensic Imaging Demo -
> =A0=A0 http://insession.blogs.cnn.com/2010/03/23/how-computer-evidenc=
e-gets-retrieved/
>
> The Norcross Group
> The Intersection of Evidence & Technology
> http://www.norcrossgroup.com



--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
=A0=A0 http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-=
gets-retrieved/

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
