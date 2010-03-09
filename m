From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: 3 disk RAID1?
Date: Mon, 8 Mar 2010 19:26:06 -0600
Message-ID: <BB.BD.21054.3B3A59B4@cdptpa-omtalb.mail.rr.com>
References: <5bdc1c8b1003081719h37f02cb9rbdc4bb6064e4c3d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003081719h37f02cb9rbdc4bb6064e4c3d7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>
Cc: 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Mark Knecht
> Sent: Monday, March 08, 2010 7:19 PM
> To: Kristleifur Da=F0ason
> Cc: Linux-RAID
> Subject: Re: 3 disk RAID1?
>=20
> On Mon, Mar 8, 2010 at 2:18 PM, Kristleifur Da=F0ason
> <kristleifur@gmail.com> wrote:
> <SNIP>
> >>
> >> When in doubt, read the manual two or three more times.
> >>
> >> This might also help you: http://wiki.tldp.org/LVM-on-RAID =A0I wr=
ote
> >> some background comparison sections when I made that...
> >
> > Good advice.
> >
> > The contents of the manual didn't really stick for me until I'd
> > actually *done* the tasks I was trying to figure out. The beautiful
> > and classic Catch-22 of learning new things. So I somewhat
> > empathically suggest you obtain a virtual machine program and start=
 up
> > a few disposable virtual machines. (VirtualBox is pretty good and a=
lso
> > free.) Try creating some RAID's on VM's and getting them to boot, t=
ry
> > failing a device and readding it, etc.
> >
> > And keep the manual in a window next to the virtual machine's windo=
w :)
> >
> > -- Kristleifur
> >
>=20
> Exactly what I'm working on this afternoon. I've not created many VM'=
s
> from scratch so there's a learning curve there, but potentially makin=
g
> the hard drives virtual in the new VM setup and then applying RAID to
> them seems like a good way to practice.
>=20
> Additionally I'm going to purchase maybe 3 or 4 drives and then see
> about using the other SATA ports on my desktop motherboard to create
> additional storage that I can get some real performance numbers on.

	Your mileage may definitely vary, but neither of the servers on
which I run mdadm have motherboards which allow mdadm to recognize the
drives.  For both of them, only drives 0 and 1 are properly recognized =
by
Linux.  I had to purchase SATA controllers for both.  Both are Asus AMD=
-64
motherboards.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
