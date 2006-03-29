From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: recovering data on a failed raid-0 installation
Date: Wed, 29 Mar 2006 00:26:43 -0500
Message-ID: <200603290526.k2T5Qmp14592@www.watkins-home.com>
References: <200603282208.47214.technomage-hawke@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200603282208.47214.technomage-hawke@cox.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Technomage' <technomage-hawke@cox.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

RAID0 uses all disks evenly (all 2 in your case).  I don=92t see how yo=
u can
recover from a drive failure with a RAID0.  Never use RAID0 unless you =
are
willing to lose all the data!

Are you sure the second disk is dead?  Have you done a read test on the
disk?  dd works well for read testing.  Try this:
dd if=3D/dev/hdb2 of=3D/dev/null bs=3D64k
or
dd if=3D/dev/hdb of=3D/dev/null bs=3D64k

Guy

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Technomage
} Sent: Wednesday, March 29, 2006 12:09 AM
} To: linux-raid@vger.kernel.org
} Subject: recovering data on a failed raid-0 installation
}=20
} ok,
} here's the situation in a nutshell.
}=20
} one of the 2 HD's in a linux raid-0 installation has failed.
}=20
} Fortunately, or otherwise, it was NOT the primary HD.
}=20
} problem is, I need to recover data from the first drive but appear to=
 be
} unable to do so because the raid is not complete. the second drive on=
ly
} had
} 193 MB written to it and I am fairly certain that the data I would li=
ke to
} recover is NOT on that drive.
}=20
} can anyone offer any solutions to this?
}=20
} the second HD is not usable (heat related failure issues).
}=20
} The filesystem used on the md0 partition (under mdadm) was xfs. now I=
 have
} tried the xfs_check and xfs_repair tools and they are not helpful at =
this
} point.
}=20
} The developer (of mdadm) suggested I use the following commands in an
} attempt
} to recover:
}=20
}   mdadm -C /dev/md0 -l0 -n2 /dev/......
}   fsck -n /dev/md0
}=20
} However, the second one was a no go.
}=20
} I am stumped as to how to proceed here. I need the data off the first
} drive,
} but do not appear to have any way (other than using cat to see it) to=
 get
} at
} it.
}=20
} some help would be greatly appreciated.
}=20
} technomage
}=20
} p. here is the original response sent back to me from the developer o=
f
} mdadm:
} ***************************
} Re: should have been more explicit here -> Re: need some help <URGENT=
!>
} From: Neil Brown <neilb@suse.de>
} To: Technomage <technomage-hawke@cox.net>
} Date: Sunday 22:01:45
} On Sunday March 26, technomage-hawke@cox.net wrote:
} > ok,
} >
} > you gave me more info than some local to that mentioned e-mail list=
=2E
} >
} > ok, the vast majority of the data I need to recover is on /dev/hda
} > and /dev/hdb only has 193 MB and is probably irrelevant.
} >
} > can you help me with this?
} > can you baby me through this. I really need to recover this data (i=
f at
} all
} > possible).
}=20
} Not really, and certainly not now (I have to go out).
} I have already make 2 suggestions
} =A0 mail linux-raid@vger.kernel.org
} and
} =A0 mdadm -C /dev/md0 -l0 -n2 /dev/......
} =A0 fsck -n /dev/md0
}=20
} try one of those.
}=20
} NeilBrown
}=20
} >
} > the friend of mine that this actually happened to is on the phone,
} begging
} me
} > and grovelling before the gods of linux in order to have this fixed=
=2E I
} have
} > setup an identical test situation here.
} >
} > the important data is on drive 1 and drive 2 is mostly irrelevant.
} > is there any way to convince raid-0 to truncate to the end of drive=
 1
} and
} > allow me to get whatever data I can off. btw, the filesystem that w=
as
} > formatted was xfs (for linux) on md0.
} >
} > if you have questions, please do not hesitate to ask.
} >
} > thank you.
} >
} > p. real name here is Eric.
} >
} >
} > On Sunday 26 March 2006 21:33, you wrote:
} > > On Sunday March 26, technomage-hawke@cox.net wrote:
} > >
} > > With a name like "Technomage" and a vague subject "need some help
} > > <URGENT>", I very really discarded your email assuming it was spa=
m!
} > >
} > > Questions like this are best sent to linux-raid@vger.kernel.org.
} > >
} > > If one drive in a raid0 has failed non-recoverably, then half you=
r
} > > data is gone, so you are out of luck.
} > >
} > > Your best bet would be to recreate the raid0 in exactly the same
} > > configuration as before, and see if you can find the data there.
} > > e.g.
} > > =A0 =A0mdadm -C /dev/md0 -l0 -n2 /dev/hda2 /dev/hdb2
} > > =A0 fsck -n /dev/md0
} > >
} > > or something like that.
} > >
} > > NeilBrown
} > >
} > > > I recently ran into a problem after an install using mdadm. the
} software
} > > > raid-0 environment suffered a failure after a HD in the system
} failed
} due
} > > > to thermal run-away.
} > > >
} > > > the setup goes like this:
} > > >
} > > > /dev/hda has:
} > > > /dev/hda1 -> boot (512 MN)
} > > > /dev/hda2 -> partition 1 (linux raid autodetect)
} > > >
} > > > /dev/hdb has:
} > > > /dev/hdb1 -> swap (512 MB)
} > > > /dev/hdb2 -> partition 2 (linux raid autodetect)
} > > >
} > > > /dev/hdb is the drive that failed. according to a drive imager,=
 only
} 129
} > > > MB of data was actually written to the second raid partition (i=
n
} serial).
} > > > unfortunately, without it, I cannot recover any data off of the
} first HD
} > > > and I would like very much to do so. Some of this data is for m=
y
} work as
} > > > a forensics examiner.
} > > >
} > > > I am fairly certain that the data I need to recover is on /dev/=
hda
} but
} so
} > > > far, I have been unable to read the data in any meaningful way
} (except
} > > > the use of cat piped through less to see if the data is, in fac=
t,
} > > > readable).
} > > >
} > > > can you help?
} > > >
} > > > thank you.
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
