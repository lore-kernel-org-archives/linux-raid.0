From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: need a little help rebuilding a raid 10
Date: Mon, 5 Dec 2011 21:05:40 -0500
Message-ID: <CAGpXXZKdbs+Y3qNHnVmFGB3sKE5R7viRajrVM+udUqoDgsA0yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

I have a raid10 that failed recently due to a failed drive slot.  The
drive is good from what I can tell.  In theory it is rebuilding now.

1) Once the current recovery process finishes, are there any commands
I can (should) issue to make sure the array is consistent.  I'm afraid
my mirror halves won't really be in sync.

2) If I want to pause the recovery and do some production real, can I
do that?  How?

=3D=3D details

Not sure why but each of the members dropped one by one until the
raid10 went offline.

I likely did something wrong by now, but I currently have it in this st=
ate:

md127 : active raid10 sdb5[4] sda5[0] sdc3[5] sdd3[2]
      923517952 blocks super 1.2 512K chunks 2 near-copies [4/3] [UUU_]
      [>....................]  recovery =3D  0.8% (4117760/461758976)
finish=3D1373.3min speed=3D5553K/sec

(it used to be md2.  No idea where md127 came from.  There are only 4
md's on the machine.)

It's currently providing a usable volume I think.  I just rebooted the
machine and the filesystem looks good at first glance.

The recovery looks very slow to me, but maybe I still have hardware iss=
ues.

The first 2 members forming a raid 1 immediately after being told
makes since to me.  I don't understand how the 3rd member got sync'ed
up so fast.  It seemed to be instantaneous and I don't think it was in
sync.

Originally it was a raid10 with
sda5 mirrored to sdb5
sdc3 mirrored to sdd3
(or so I believe)

Immediately after the failure I had nothing, so I did:
# mdadm --stop /dev/md2

# mdadm --create /dev/md2 -v --assume-clean --level=3Draid10
--raid-devices=3D4 /dev/sda5 missing /dev/sdd3 missing

(or similar, my sdX names have been changing as this event progresses.
These names are based on what I see in mdstat.)

I ran that way for a day, which is why I really don't think either of
the missing mirror halves should have immediately sync'ed.

Anyway, I have a backup but I prefer not to use it if it can be
avoided.  (the machine is in sporadic production, for an hour or two
at a time, and going offline for a day to recreate it from scratch
does not sound like fun.)


Thanks
Greg
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
