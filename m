From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: read errors corrected
Date: Thu, 30 Dec 2010 20:56:58 -0500
Message-ID: <67AE53F6035A4A2C9A518C96BCEE54BA@m5>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com>
 <20101230201501.2f39a85f@notabene.brown>
 <AANLkTik2+Gk1XveqD=crGMH5JshzJqQb_i77ZpOFUncB@mail.gmail.com>
 <AANLkTi=vBWKjQStwpWZ3b=YL93LTDBfGk7b5jKUHLcO7@mail.gmail.com>
 <20101231101243.666e0f9e@notabene.brown>
 <AANLkTimhWHfcnDH4Zy6=VGX17_JAH0ON3OMuPhA4oBjf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTimhWHfcnDH4Zy6=VGX17_JAH0ON3OMuPhA4oBjf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'James' <jtp@nc.rr.com>, 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of James
} Sent: Thursday, December 30, 2010 8:48 PM
} To: Neil Brown
} Cc: linux-raid@vger.kernel.org
} Subject: Re: read errors corrected
}=20
} Neil,
}=20
} I'm runinng 2.6.35.
}=20
} Although an expensive route, the only thing I can think to do to
} determine 100% whether the issue is software or hardware (and, if
} hardware, whether SATA controller or the drives) is to swap the drive=
s
} out.
}=20
} Ouch!
}=20
} Any other ideas, however, would be appreciated before I drop a few
} hundred bucks. :)

Just swap out 1 for now?  :)

I believe your drives are fine because your smart stats don't reflect t=
he
number of errors you see in the logs.

}=20
} -james
}=20
} On Thu, Dec 30, 2010 at 23:12, Neil Brown <neilb@suse.de> wrote:
} > On Thu, 30 Dec 2010 11:35:59 -0500 James <jtp@nc.rr.com> wrote:
} >
} >> Sorry Neil, I meant to reply-all.
} >>
} >> -james
} >>
} >> On Thu, Dec 30, 2010 at 11:35, James <jtp@nc.rr.com> wrote:
} >> > Inline.
} >> >
} >> > On Thu, Dec 30, 2010 at 04:15, Neil Brown <neilb@suse.de> wrote:
} >> >> On Thu, 30 Dec 2010 03:20:48 +0000 James <jtp@nc.rr.com> wrote:
} >> >>
} >> >>> All,
} >> >>>
} >> >>> I'm looking for a bit of guidance here. I have a RAID 6 set up=
 on
} my
} >> >>> system and am seeing some errors in my logs as follows:
} >> >>>
} >> >>> # cat messages | grep "read erro"
} >> >>> Dec 15 15:40:34 nuova kernel: md/raid:md4: read error correcte=
d (8
} >> >>> sectors at 974262528 on sda4)
} >> >>> Dec 15 15:40:34 nuova kernel: md/raid:md4: read error correcte=
d (8
} >> >>> sectors at 974262536 on sda4)
} >> >> .....
} >> >>
} >> >>>
} >> >>> I've Google'd the heck out of this error message but am not se=
eing
} a
} >> >>> clear and concise message: is this benign? What would cause th=
ese
} >> >>> errors? Should I be concerned?
} >> >>>
} >> >>> There is an error message (read error corrected) on each of th=
e
} drives
} >> >>> in the array. They all seem to be functioning properly. The I/=
O on
} the
} >> >>> drives is pretty heavy for some parts of the day.
} >> >>>
} >> >>> # cat /proc/mdstat
} >> >>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [rai=
d5]
} >> >>> [raid4] [multipath]
} >> >>> md1 : active raid6 sdb1[1] sda1[0] sdd1[3] sdc1[2]
} >> >>> =A0 =A0 =A0 497792 blocks level 6, 64k chunk, algorithm 2 [4/4=
] [UUUU]
} >> >>>
} >> >>> md2 : active raid6 sdb2[1] sda2[0] sdd2[3] sdc2[2]
} >> >>> =A0 =A0 =A0 4000000 blocks level 6, 64k chunk, algorithm 2 [4/=
4] [UUUU]
} >> >>>
} >> >>> md3 : active raid6 sdb3[1] sda3[0] sdd3[3] sdc3[2]
} >> >>> =A0 =A0 =A0 25992960 blocks level 6, 64k chunk, algorithm 2 [4=
/4] [UUUU]
} >> >>>
} >> >>> md4 : active raid6 sdb4[1] sda4[0] sdd4[3] sdc4[2]
} >> >>> =A0 =A0 =A0 2899780480 blocks level 6, 64k chunk, algorithm 2 =
[4/4]
} [UUUU]
} >> >>>
} >> >>> unused devices: <none>
} >> >>>
} >> >>> I have a really hard time believing there's something wrong wi=
th
} all
} >> >>> of the drives in the array, although admittedly they're the sa=
me
} model
} >> >>> from the same manufacturer.
} >> >>>
} >> >>> Can someone point me in the right direction?
} >> >>> (a) what causes these errors precisely?
} >> >>
} >> >> When md/raid6 tries to read from a device and gets a read error=
, it
} try to
} >> >> read from other other devices. =A0When that succeeds it compute=
s the
} data that
} >> >> it had tried to read and then write it back to the original dri=
ve.
} =A0If this
} >> >> succeeded is assumes that the read error has been correct by a
} write, and
} >> >> prints the message that you see.
} >> >>
} >> >>
} >> >>> (b) is the error benign? How can I determine if it is *likely*=
 a
} >> >>> hardware problem? (I imagine it's probably impossible to tell =
if
} it's
} >> >>> HW until it's too late)
} >> >>
} >> >> A few occasional messages like this are fairly benign. =A0The c=
ould be
} a sign
} >> >> that the drive surface is degrading. =A0If you see lots of thes=
e
} messages, then
} >> >> you should seriously consider replacing the drive.
} >> >
} >> > Wow, this is hard for me to believe considering this is happenin=
g on
} >> > all the drives. It's not impossible, however, since the drives a=
re
} >> > likely from the same batch.
} >> >
} >> >> As you are seeing these message across all devices, it is possi=
ble
} that the
} >> >> problem is with the sata controller rather than the disks. =A0D=
o know
} which you
} >> >> should check the errors that are reported in dmesg. =A0If you d=
on't
} understand
} >> >> these message, then post them to the list - feel free to post
} several hundred
} >> >> lines of logs - too much is much much better than not enough.
} >> >
} >> > I posted a few errors in my response to the thread a bit ago --
} here's
} >> > another snippet:
} >> >
} >> > Dec 29 01:55:03 nuova kernel: sd 1:0:0:0: [sdc] Unhandled error =
code
} >> > Dec 29 01:55:03 nuova kernel: sd 1:0:0:0: [sdc] Result: hostbyte=
=3D0x00
} >> > driverbyte=3D0x06
} >> > Dec 29 01:55:03 nuova kernel: sd 1:0:0:0: [sdc] CDB: cdb[0]=3D0x=
28: 28
} >> > 00 25 a2 a0 6a 00 00 80 00
} >> > Dec 29 01:55:03 nuova kernel: end_request: I/O error, dev sdc, s=
ector
} 631414890
} >> > Dec 29 01:55:03 nuova kernel: sd 0:0:1:0: [sdb] Unhandled error =
code
} >> > Dec 29 01:55:03 nuova kernel: sd 0:0:1:0: [sdb] Result: hostbyte=
=3D0x00
} >> > driverbyte=3D0x06
} >
} > "Unhandled error code" sounds like it could be a driver problem...
} >
} > Try googling that error message...
} >
} > http://us.generation-nt.com/answer/2-6-33-libata-issues-via-sata-pa=
ta-
} controller-help-197123882.html
} >
} >
} > "Also, please try the latest 2.6.34-rc kernel, as that has several =
fixes
} > for both pata_via and sata_via which did not make 2.6.33."
} >
} > What kernel are =A0you running???
} >
} > NeilBrown
} >
} >
} >
} >
} >> > Dec 29 01:55:03 nuova kernel: sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x=
28: 28
} >> > 00 25 a2 a0 ea 00 00 38 00
} >> > Dec 29 01:55:03 nuova kernel: end_request: I/O error, dev sdb, s=
ector
} 631415018
} >> > Dec 29 01:58:23 nuova kernel: md/raid:md4: read error corrected =
(8
} >> > sectors at 600923648 on sdb4)
} >> > Dec 29 01:58:23 nuova kernel: md/raid:md4: read error corrected =
(8
} >> > sectors at 600923656 on sdb4)
} >> > Dec 29 01:58:23 nuova kernel: md/raid:md4: read error corrected =
(8
} >> > sectors at 600923664 on sdb4)
} >> > Dec 29 01:58:23 nuova kernel: md/raid:md4: read error corrected =
(8
} >> > sectors at 600923672 on sdb4)
} >> > Dec 29 01:58:23 nuova kernel: md/raid:md4: read error corrected =
(8
} >> > sectors at 600923680 on sdb4)
} >> > Dec 29 01:58:23 nuova kernel: md/raid:md4: read error corrected =
(8
} >> > sectors at 600923688 on sdb4)
} >> > Dec 29 01:58:23 nuova kernel: md/raid:md4: read error corrected =
(8
} >> > sectors at 600923696 on sdb4)
} >> > Dec 29 01:58:23 nuova kernel: md/raid:md4: read error corrected =
(8
} >> > sectors at 600923520 on sdc4)
} >> > Dec 29 01:58:23 nuova kernel: md/raid:md4: read error corrected =
(8
} >> > sectors at 600923528 on sdc4)
} >> > Dec 29 01:58:23 nuova kernel: md/raid:md4: read error corrected =
(8
} >> > sectors at 600923536 on sdc4)
} >> >
} >> > Is there a good way to determine if the issue is with the mother=
board
} >> > (where the SATA controller is), or with the drives themselves?
} >> >
} >> >> NeilBrown
} >> >>
} >> >>
} >> >>
} >> >>> (c) are these errors expected in a RAID array that is heavily =
used?
} >> >>> (d) what kind of errors should I see regarding "read errors" t=
hat
} >> >>> *would* indicate an imminent hardware failure?
} >> >>>
} >> >>> Thoughts and ideas would be welcomed. I'm sure a thread where =
some
} >> >>> hefty discussion is thrown at this topic will help future Goog=
lers
} >> >>> like me. :)
} >> >>>
} >> >>> -james
} >> >>> --
} >> >>> To unsubscribe from this list: send the line "unsubscribe linu=
x-
} raid" in
} >> >>> the body of a message to majordomo@vger.kernel.org
} >> >>> More majordomo info at =A0http://vger.kernel.org/majordomo-inf=
o.html
} >> >>
} >> >>
} >> >
} >
} >
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
