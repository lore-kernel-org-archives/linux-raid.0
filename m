From: Technomage <technomage-hawke@cox.net>
Subject: addendum: was Re: recovering data on a failed raid-0 installation
Date: Wed, 29 Mar 2006 21:14:37 -0700
Message-ID: <200603292114.37439.technomage-hawke@cox.net>
References: <200603290526.k2T5Qmp14592@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200603290526.k2T5Qmp14592@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ok, guy and others.

this is a followup to the case I am currently trying (still) to solve.

synopsis:
the general consensus is that raid0 writes in a striping fashion.

However, the test case I have here doesn't appear to operate in the abo=
ve=20
described manner. what was observed was this: on /dev/mdo (while observ=
ing=20
drive activity for both hda and hdb) hda was active until filled at whi=
ch=20
point data was spanned to hdb.  In other words, the data was written in=
 a=20
linear, not striped, manner.=20

given this behavior (as observed), it stands to reason that the data on=
 the=20
first of the 2 members of this "raid" should be recoverable, if only we=
 could=20
"trick" the raid into allowing us to mount it without its second member=
=2E at=20
this point, we are assuming that the data on drive 2 (hdb) is not=20
recoverable.=20

In a scientific fashion, assuming that the observed behavior is correct=
, how=20
would one go about recovering data from the first member without the se=
cond=20
being present? I assume that we are going to have to use mdadm in such =
a way=20
as to trick it into thinking it is doing something that it is not. I in=
vite=20
anyone here to setup a similar testing environment to confirm these res=
ults.

drives: 2 identical IDE drives (same make/model)
suse 9.3 os.

p.s. I have heard all the "naysayer commentary" so please, keep it to U=
SEFUL=20
information only. thanks....

On Tuesday 28 March 2006 22:26, you wrote:
> RAID0 uses all disks evenly (all 2 in your case).  I don=92t see how =
you can
> recover from a drive failure with a RAID0.  Never use RAID0 unless yo=
u are
> willing to lose all the data!
>
> Are you sure the second disk is dead?  Have you done a read test on t=
he
> disk?  dd works well for read testing.  Try this:
> dd if=3D/dev/hdb2 of=3D/dev/null bs=3D64k
> or
> dd if=3D/dev/hdb of=3D/dev/null bs=3D64k
>
> Guy
>
> } -----Original Message-----
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> } owner@vger.kernel.org] On Behalf Of Technomage
> } Sent: Wednesday, March 29, 2006 12:09 AM
> } To: linux-raid@vger.kernel.org
> } Subject: recovering data on a failed raid-0 installation
> }
> } ok,
> } here's the situation in a nutshell.
> }
> } one of the 2 HD's in a linux raid-0 installation has failed.
> }
> } Fortunately, or otherwise, it was NOT the primary HD.
> }
> } problem is, I need to recover data from the first drive but appear =
to be
> } unable to do so because the raid is not complete. the second drive =
only
> } had
> } 193 MB written to it and I am fairly certain that the data I would =
like
> to } recover is NOT on that drive.
> }
> } can anyone offer any solutions to this?
> }
> } the second HD is not usable (heat related failure issues).
> }
> } The filesystem used on the md0 partition (under mdadm) was xfs. now=
 I
> have } tried the xfs_check and xfs_repair tools and they are not help=
ful at
> this } point.
> }
> } The developer (of mdadm) suggested I use the following commands in =
an
> } attempt
> } to recover:
> }
> }   mdadm -C /dev/md0 -l0 -n2 /dev/......
> }   fsck -n /dev/md0
> }
> } However, the second one was a no go.
> }
> } I am stumped as to how to proceed here. I need the data off the fir=
st
> } drive,
> } but do not appear to have any way (other than using cat to see it) =
to get
> } at
> } it.
> }
> } some help would be greatly appreciated.
> }
> } technomage
> }
> } p. here is the original response sent back to me from the developer=
 of
> } mdadm:
> } ***************************
> } Re: should have been more explicit here -> Re: need some help <URGE=
NT!>
> } From: Neil Brown <neilb@suse.de>
> } To: Technomage <technomage-hawke@cox.net>
> } Date: Sunday 22:01:45
> } On Sunday March 26, technomage-hawke@cox.net wrote:
> } > ok,
> } >
> } > you gave me more info than some local to that mentioned e-mail li=
st.
> } >
> } > ok, the vast majority of the data I need to recover is on /dev/hd=
a
> } > and /dev/hdb only has 193 MB and is probably irrelevant.
> } >
> } > can you help me with this?
> } > can you baby me through this. I really need to recover this data =
(if at
> } all
> } > possible).
> }
> } Not really, and certainly not now (I have to go out).
> } I have already make 2 suggestions
> } =A0 mail linux-raid@vger.kernel.org
> } and
> } =A0 mdadm -C /dev/md0 -l0 -n2 /dev/......
> } =A0 fsck -n /dev/md0
> }
> } try one of those.
> }
> } NeilBrown
> }
> } >
> } > the friend of mine that this actually happened to is on the phone=
,
> } begging
> } me
> } > and grovelling before the gods of linux in order to have this fix=
ed. I
> } have
> } > setup an identical test situation here.
> } >
> } > the important data is on drive 1 and drive 2 is mostly irrelevant=
=2E
> } > is there any way to convince raid-0 to truncate to the end of dri=
ve 1
> } and
> } > allow me to get whatever data I can off. btw, the filesystem that=
 was
> } > formatted was xfs (for linux) on md0.
> } >
> } > if you have questions, please do not hesitate to ask.
> } >
> } > thank you.
> } >
> } > p. real name here is Eric.
> } >
> } >
> } > On Sunday 26 March 2006 21:33, you wrote:
> } > > On Sunday March 26, technomage-hawke@cox.net wrote:
> } > >
> } > > With a name like "Technomage" and a vague subject "need some he=
lp
> } > > <URGENT>", I very really discarded your email assuming it was s=
pam!
> } > >
> } > > Questions like this are best sent to linux-raid@vger.kernel.org=
=2E
> } > >
> } > > If one drive in a raid0 has failed non-recoverably, then half y=
our
> } > > data is gone, so you are out of luck.
> } > >
> } > > Your best bet would be to recreate the raid0 in exactly the sam=
e
> } > > configuration as before, and see if you can find the data there=
=2E
> } > > e.g.
> } > > =A0 =A0mdadm -C /dev/md0 -l0 -n2 /dev/hda2 /dev/hdb2
> } > > =A0 fsck -n /dev/md0
> } > >
> } > > or something like that.
> } > >
> } > > NeilBrown
> } > >
> } > > > I recently ran into a problem after an install using mdadm. t=
he
> } software
> } > > > raid-0 environment suffered a failure after a HD in the syste=
m
> } failed
> } due
> } > > > to thermal run-away.
> } > > >
> } > > > the setup goes like this:
> } > > >
> } > > > /dev/hda has:
> } > > > /dev/hda1 -> boot (512 MN)
> } > > > /dev/hda2 -> partition 1 (linux raid autodetect)
> } > > >
> } > > > /dev/hdb has:
> } > > > /dev/hdb1 -> swap (512 MB)
> } > > > /dev/hdb2 -> partition 2 (linux raid autodetect)
> } > > >
> } > > > /dev/hdb is the drive that failed. according to a drive image=
r,
> only } 129
> } > > > MB of data was actually written to the second raid partition =
(in
> } serial).
> } > > > unfortunately, without it, I cannot recover any data off of t=
he
> } first HD
> } > > > and I would like very much to do so. Some of this data is for=
 my
> } work as
> } > > > a forensics examiner.
> } > > >
> } > > > I am fairly certain that the data I need to recover is on /de=
v/hda
> } but
> } so
> } > > > far, I have been unable to read the data in any meaningful wa=
y
> } (except
> } > > > the use of cat piped through less to see if the data is, in f=
act,
> } > > > readable).
> } > > >
> } > > > can you help?
> } > > >
> } > > > thank you.
> } -
> } To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> } the body of a message to majordomo@vger.kernel.org
> } More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
