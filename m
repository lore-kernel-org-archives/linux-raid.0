From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: RAID 5 array recovery - two drives errors in external enclosure
Date: Mon, 21 Sep 2009 00:59:31 -0400
Message-ID: <10B9F79B81B742F0B915FECC020A8800@m5>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com> <6b696870909180910q67d8166ay7796321b8cd35809@mail.gmail.com> <2267211f0909180912p745e4ea0idb5659cb54a6adce@mail.gmail.com> <6b696870909180923m35f29fa2l857b6f6402eb20be@mail.gmail.com> <2267211f0909181041o29d6f5eft1e260696c6ab9c57@mail.gmail.com> <6b696870909181317x777e3c5dsdcf0e7709f9c4979@mail.gmail.com> <2267211f0909181630r33fcdbe5hb0d158b9bf12924b@mail.gmail.com> <70ed7c3e0909181637g35b31926ref7e4a16beaab73c@mail.gmail.com> <1f0f1a960909181817s6ad0a3f3l386a478603e9fde8@mail.gmail.com> <AFD5FB84146A49B186DAB822C95DE16D@m5> <2267211f0909202140m54039f77rce262283eb4e371@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2267211f0909202140m54039f77rce262283eb4e371@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Tim Bostrom' <tbostrom@gmail.com>
Cc: 'Tom Carlson' <twigathy@gmail.com>, "'Majed B.'" <majedb@gmail.com>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I think the order of your drives changed.  But I don't know how.  You s=
hould
not have done another create, because it destroys the superblocks.  You
should have done an assemble, listing all drives and not using missing.=
  Md
should find all the correct drives.  Or if it said 1 was wrong, just tr=
y
again and don't list that one.

Anyway, glad you got your data.

} -----Original Message-----
} From: Tim Bostrom [mailto:tbostrom@gmail.com]
} Sent: Monday, September 21, 2009 12:41 AM
} To: Guy Watkins
} Cc: Tom Carlson; Majed B.; linux-raid
} Subject: Re: RAID 5 array recovery - two drives errors in external
} enclosure
}=20
} Well, thank god I copied everything off the array this weekend, but
} strange:
}=20
} I had gotten the array up finally with the correct order and missing
} drive:
}=20
} mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sdf1 /dev/sdc1 /dev/sdb1
} /dev/sdd1 missing
}=20
} ------------
} After copying everything off, I power-cycled my server and tried to
} bring the array back up again using:
}=20
} mdadm -A /dev/md0 /dev/sdf1 /dev/sdc1 /dev/sdb1 /dev/sdd1 missing
}=20
} I received the error : mdadm: superblock on /dev/sdc1 doesn't match
} others - assembly aborted.
}=20
} This is strange since I had this seemingly working and was able to
} copy all the data offline this weekend.
} Drives haven't changed order - I haven't unplugged anything or change=
d
} any cords.
}=20
} Another issue of the command that worked before on the array:
} mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sdf1 /dev/sdc1 /dev/sdb1
} /dev/sdd1 missing
}=20
} yields my old problem of not being able to mount.
} EXT3-fs: md0: couldn't mount because of unsupported optional features
} (3fd18e00).
} mount: wrong fs type, bad option, bad superblock on /dev/md0,
}        missing codepage or helper program, or other error
}        In some cases useful info is found in syslog - try
}        dmesg | tail  or so
}=20
} What gives?  The drive order couldn't have changed just through a
} reboot.   All the same number of drives and drive letters are there.
}=20
}=20
} -Tim
}=20
}=20
}=20
} On Fri, Sep 18, 2009 at 6:35 PM, Guy Watkins <guy@watkins-home.com> w=
rote:
} > If you are starting over, maybe you should use RAID6?
} >
} > } -----Original Message-----
} > } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} > } owner@vger.kernel.org] On Behalf Of Tom Carlson
} > } Sent: Friday, September 18, 2009 9:18 PM
} > } To: Majed B.
} > } Cc: Tim Bostrom; linux-raid
} > } Subject: Re: RAID 5 array recovery - two drives errors in externa=
l
} > } enclosure
} > }
} > } 2009/9/19 Majed B. <majedb@gmail.com>:
} > } > If you're going to take all your data out, I would suggest you =
do a
} > } > clean start and zero out all the disks to force the remapping o=
f bad
} > } > sectors, then run smartctl -t offline on all disks and after it=
's
} done
} > } > (it will take A LONG time), create your filesystem on an array =
and
} put
} > } > back your data.
} > }
} > } I'd recommend running the badblocks program on each device to be =
put
} > } in the array too, just to be certain that none of your disks are =
going
} > } to go horribly flakey on assembly and build... I'm not sure if th=
e
} > } offline smart test does a full scan like badblocks would.
} > }
} > } T
} > } --
} > } To unsubscribe from this list: send the line "unsubscribe linux-r=
aid"
} in
} > } the body of a message to majordomo@vger.kernel.org
} > } More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
} >
} >
}=20
}=20
}=20
} --
} -tim

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
