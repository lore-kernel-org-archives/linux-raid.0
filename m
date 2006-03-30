From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: addendum: was Re: recovering data on a failed raid-0 installation
Date: Thu, 30 Mar 2006 00:04:27 -0500
Message-ID: <200603300504.k2U54Wp20349@www.watkins-home.com>
References: <200603292114.37439.technomage-hawke@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200603292114.37439.technomage-hawke@cox.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Technomage' <technomage-hawke@cox.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If what you say is true, then it was not a RAID0.  It sounds like LINEA=
R.
Do you have the original command used to create the array?
Or the output from mdadm before you tried any recovery methods.
The output must be from before you re-created the array.
Output from commands like "mdadm -D /dev/md0" or "mdadm -E /dev/hda2".
Or the output from "cat /proc/mdstat", from before you re-created the a=
rray.

Guy


} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Technomage
} Sent: Wednesday, March 29, 2006 11:15 PM
} To: Guy
} Cc: linux-raid@vger.kernel.org
} Subject: addendum: was Re: recovering data on a failed raid-0 install=
ation
}=20
} ok, guy and others.
}=20
} this is a followup to the case I am currently trying (still) to solve=
=2E
}=20
} synopsis:
} the general consensus is that raid0 writes in a striping fashion.
}=20
} However, the test case I have here doesn't appear to operate in the a=
bove
} described manner. what was observed was this: on /dev/mdo (while obse=
rving
} drive activity for both hda and hdb) hda was active until filled at w=
hich
} point data was spanned to hdb.  In other words, the data was written =
in a
} linear, not striped, manner.
}=20
} given this behavior (as observed), it stands to reason that the data =
on
} the
} first of the 2 members of this "raid" should be recoverable, if only =
we
} could
} "trick" the raid into allowing us to mount it without its second memb=
er.
} at
} this point, we are assuming that the data on drive 2 (hdb) is not
} recoverable.
}=20
} In a scientific fashion, assuming that the observed behavior is corre=
ct,
} how
} would one go about recovering data from the first member without the
} second
} being present? I assume that we are going to have to use mdadm in suc=
h a
} way
} as to trick it into thinking it is doing something that it is not. I
} invite
} anyone here to setup a similar testing environment to confirm these
} results.
}=20
} drives: 2 identical IDE drives (same make/model)
} suse 9.3 os.
}=20
} p.s. I have heard all the "naysayer commentary" so please, keep it to
} USEFUL
} information only. thanks....
}=20
} On Tuesday 28 March 2006 22:26, you wrote:
} > RAID0 uses all disks evenly (all 2 in your case).  I don=92t see ho=
w you
} can
} > recover from a drive failure with a RAID0.  Never use RAID0 unless =
you
} are
} > willing to lose all the data!
} >
} > Are you sure the second disk is dead?  Have you done a read test on=
 the
} > disk?  dd works well for read testing.  Try this:
} > dd if=3D/dev/hdb2 of=3D/dev/null bs=3D64k
} > or
} > dd if=3D/dev/hdb of=3D/dev/null bs=3D64k
} >
} > Guy
} >
} > } -----Original Message-----
} > } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} > } owner@vger.kernel.org] On Behalf Of Technomage
} > } Sent: Wednesday, March 29, 2006 12:09 AM
} > } To: linux-raid@vger.kernel.org
} > } Subject: recovering data on a failed raid-0 installation
} > }
} > } ok,
} > } here's the situation in a nutshell.
} > }
} > } one of the 2 HD's in a linux raid-0 installation has failed.
} > }
} > } Fortunately, or otherwise, it was NOT the primary HD.
} > }
} > } problem is, I need to recover data from the first drive but appea=
r to
} be
} > } unable to do so because the raid is not complete. the second driv=
e
} only
} > } had
} > } 193 MB written to it and I am fairly certain that the data I woul=
d
} like
} > to } recover is NOT on that drive.
} > }
} > } can anyone offer any solutions to this?
} > }
} > } the second HD is not usable (heat related failure issues).
} > }
} > } The filesystem used on the md0 partition (under mdadm) was xfs. n=
ow I
} > have } tried the xfs_check and xfs_repair tools and they are not he=
lpful
} at
} > this } point.
} > }
} > } The developer (of mdadm) suggested I use the following commands i=
n an
} > } attempt
} > } to recover:
} > }
} > }   mdadm -C /dev/md0 -l0 -n2 /dev/......
} > }   fsck -n /dev/md0
} > }
} > } However, the second one was a no go.
} > }
} > } I am stumped as to how to proceed here. I need the data off the f=
irst
} > } drive,
} > } but do not appear to have any way (other than using cat to see it=
) to
} get
} > } at
} > } it.
} > }
} > } some help would be greatly appreciated.
} > }
} > } technomage
} > }
} > } p. here is the original response sent back to me from the develop=
er of
} > } mdadm:
} > } ***************************
} > } Re: should have been more explicit here -> Re: need some help
} <URGENT!>
} > } From: Neil Brown <neilb@suse.de>
} > } To: Technomage <technomage-hawke@cox.net>
} > } Date: Sunday 22:01:45
} > } On Sunday March 26, technomage-hawke@cox.net wrote:
} > } > ok,
} > } >
} > } > you gave me more info than some local to that mentioned e-mail =
list.
} > } >
} > } > ok, the vast majority of the data I need to recover is on /dev/=
hda
} > } > and /dev/hdb only has 193 MB and is probably irrelevant.
} > } >
} > } > can you help me with this?
} > } > can you baby me through this. I really need to recover this dat=
a (if
} at
} > } all
} > } > possible).
} > }
} > } Not really, and certainly not now (I have to go out).
} > } I have already make 2 suggestions
} > } =A0 mail linux-raid@vger.kernel.org
} > } and
} > } =A0 mdadm -C /dev/md0 -l0 -n2 /dev/......
} > } =A0 fsck -n /dev/md0
} > }
} > } try one of those.
} > }
} > } NeilBrown
} > }
} > } >
} > } > the friend of mine that this actually happened to is on the pho=
ne,
} > } begging
} > } me
} > } > and grovelling before the gods of linux in order to have this f=
ixed.
} I
} > } have
} > } > setup an identical test situation here.
} > } >
} > } > the important data is on drive 1 and drive 2 is mostly irreleva=
nt.
} > } > is there any way to convince raid-0 to truncate to the end of d=
rive
} 1
} > } and
} > } > allow me to get whatever data I can off. btw, the filesystem th=
at
} was
} > } > formatted was xfs (for linux) on md0.
} > } >
} > } > if you have questions, please do not hesitate to ask.
} > } >
} > } > thank you.
} > } >
} > } > p. real name here is Eric.
} > } >
} > } >
} > } > On Sunday 26 March 2006 21:33, you wrote:
} > } > > On Sunday March 26, technomage-hawke@cox.net wrote:
} > } > >
} > } > > With a name like "Technomage" and a vague subject "need some =
help
} > } > > <URGENT>", I very really discarded your email assuming it was
} spam!
} > } > >
} > } > > Questions like this are best sent to linux-raid@vger.kernel.o=
rg.
} > } > >
} > } > > If one drive in a raid0 has failed non-recoverably, then half=
 your
} > } > > data is gone, so you are out of luck.
} > } > >
} > } > > Your best bet would be to recreate the raid0 in exactly the s=
ame
} > } > > configuration as before, and see if you can find the data the=
re.
} > } > > e.g.
} > } > > =A0 =A0mdadm -C /dev/md0 -l0 -n2 /dev/hda2 /dev/hdb2
} > } > > =A0 fsck -n /dev/md0
} > } > >
} > } > > or something like that.
} > } > >
} > } > > NeilBrown
} > } > >
} > } > > > I recently ran into a problem after an install using mdadm.=
 the
} > } software
} > } > > > raid-0 environment suffered a failure after a HD in the sys=
tem
} > } failed
} > } due
} > } > > > to thermal run-away.
} > } > > >
} > } > > > the setup goes like this:
} > } > > >
} > } > > > /dev/hda has:
} > } > > > /dev/hda1 -> boot (512 MN)
} > } > > > /dev/hda2 -> partition 1 (linux raid autodetect)
} > } > > >
} > } > > > /dev/hdb has:
} > } > > > /dev/hdb1 -> swap (512 MB)
} > } > > > /dev/hdb2 -> partition 2 (linux raid autodetect)
} > } > > >
} > } > > > /dev/hdb is the drive that failed. according to a drive ima=
ger,
} > only } 129
} > } > > > MB of data was actually written to the second raid partitio=
n (in
} > } serial).
} > } > > > unfortunately, without it, I cannot recover any data off of=
 the
} > } first HD
} > } > > > and I would like very much to do so. Some of this data is f=
or my
} > } work as
} > } > > > a forensics examiner.
} > } > > >
} > } > > > I am fairly certain that the data I need to recover is on
} /dev/hda
} > } but
} > } so
} > } > > > far, I have been unable to read the data in any meaningful =
way
} > } (except
} > } > > > the use of cat piped through less to see if the data is, in
} fact,
} > } > > > readable).
} > } > > >
} > } > > > can you help?
} > } > > >
} > } > > > thank you.
} > } -
} > } To unsubscribe from this list: send the line "unsubscribe linux-r=
aid"
} in
} > } the body of a message to majordomo@vger.kernel.org
} > } More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
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
