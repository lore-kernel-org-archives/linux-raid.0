From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Tue, 22 Sep 2009 20:56:35 -0400
Message-ID: <4A068903F71144E789C38AA1B5AB8320@m5>
References: <70ed7c3e0909220823v40badc3fu4c11e8712028535b@mail.gmail.com> <200909221442804.SM02380@trainer> <70ed7c3e0909221714n1ad1ef80oedf329f17f7dad1c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909221714n1ad1ef80oedf329f17f7dad1c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>, 'Sunpyo Hong' <sunpyo.hong@amac.com>
Cc: 'Robin Hill' <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have not paid attention to this thread.  So, might be asking a stupid
question...

Are the disks from a system of the same platform?  If not, maybe the by=
te
ordering is different?  I think I recall this as an issue with the 0.9
superblock, but I think it was not an issue with a newer superblock.  M=
aybe
it was just a feature request.  Not sure.

Anyway, mdadm supports "byteorder".  man mdadm for more info.  I have n=
ever
used it.

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Majed B.
} Sent: Tuesday, September 22, 2009 8:14 PM
} To: Sunpyo Hong
} Cc: Robin Hill; linux-raid@vger.kernel.org
} Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
}=20
} If you are sure that you have created the array with the proper order
} of disks (They MUST be in the correct order! Your disks may have
} changed their names for some reason -- verify that they are in
} order!!) and that you have assembled them properly, I would suggest
} you run a tool called "testdisk"
}=20
} You may have a corrupt filesystem, and testdisk would try to fix it.
} Also, to make sure that you have assembled the array in the correct
} order, and if the filesystem can't be fixed if it's corrupt, use a
} file-recovery tool like foremost or magicrescue and see if they
} recover your data.
}=20
} On Tue, Sep 22, 2009 at 9:42 PM, Sunpyo Hong <sunpyo.hong@amac.com> w=
rote:
} > Nothing showed up when I did =A0"sudo lvscan". I'm pretty much stum=
ped.
} >
} > -----Original Message-----
} > From: Majed B. [mailto:majedb@gmail.com]
} > Sent: Tuesday, September 22, 2009 11:24 AM
} > To: Sunpyo Hong
} > Cc: Robin Hill; linux-raid@vger.kernel.org
} > Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
} >
} > When the array is properly assembled, "sudo lvscan" should show any
} > logical volumes. Maybe even without the array assembled.
} >
} > If nothing shows up, then you don't have an LV configured.
} >
} > On Tue, Sep 22, 2009 at 6:15 PM, Sunpyo Hong <sunpyo.hong@amac.com>
} wrote:
} >>> I am stopping and starting the array. I couldn't mount in both
} instances.
} >>> The before is the initial assembly array that I force assembled
} through
} >>> mdadm -Af. This assembled the raid, but couldn't see an ext3 file
} system.
} >>
} >>>I haven't followed all of this thread, so maybe I missed something=
,
} >>>but have you considered the possibility that there is an LVM confi=
g
} >>>on the md array, and that the ext3 filesystem is inside a logical
} >>>volume?
} >>
} >>>NeilBrown
} >>
} >> Hi Neil, I already checked with western digital and its support te=
am.
} What
} >> they've told me is that the Raid is an EXT3 and is not LVM config =
on
} the
} > HD,
} >> however knowing WD they might just say that so I'd fork over the c=
ash
} to
} > get
} >> my HD recovered for thousands of dollars from them. Is there a way=
 I
} can
} >> check if it's LVM config-ed? Thanks!
} >>
} >>
} >> --
} >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id"
} in
} >> the body of a message to majordomo@vger.kernel.org
} >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
} >>
} >
} >
} >
} > --
} > =A0 =A0 =A0 Majed B.
} >
} >
}=20
}=20
}=20
} --
}        Majed B.
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
