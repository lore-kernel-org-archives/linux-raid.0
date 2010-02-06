From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
	support handoff after pivotroot
Date: Sat, 6 Feb 2010 14:07:03 -0700
Message-ID: <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	 <1263242294-5353-3-git-send-email-dledford@redhat.com>
	 <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>
	 <20100204174009.6072ec07@notabene.brown> <4B6B15B3.8030205@redhat.com>
	 <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
	 <4B6DAC06.6060909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6DAC06.6060909-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin f krafft <madduck-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

>> 1/ If you take a look at native md superblock support you see that t=
he
>> support code is duplicated between kernel-space and user space, havi=
ng
>> it all handled in userspace means only one code base to maintain
>> (elegant aspect #1).
>
> Elegance is in the eye of the beholder. =A0More on that in a minute.
>

True, but let's agree that superblock formats are quirky, arbitrary
and all around inelegant.  Only needing to write that code once is at
the very least an aid to one's sanity.

>> 2/ The kernel can simply worry about the *mechanism* of providing ra=
id
>> while all the assembly *policy* and support for any number of
>> superblock formats is relegated to where policy belongs (elegant
>> aspect #2).
>
> I would argue that dirty/clean state manipulation is *not* policy and
> *is* mechanism. =A0So, by your definition of what should be in the ke=
rnel
> combined with my definition of what dirty/clean state manipulation is=
,
> the solution is not only not elegant, it's flat incorrect.

You are conveniently blurring the lines between event generation and
event handling.  The kernel handles all the detail of detecting,
notifying and reaping the event.  The arbitrary superblock specific
actions that need to happen in response to that event are really not
very interesting to rest of the mechanism of providing raid.  You
could argue that I am conveniently drawing a line, and you would be
right.  There are convenient aspects of having this portion of the
solution in userspace which do not compromise the integrity of the
raid mechanism.

We can now also handle spare assignment policy, hot-plug policy,
corner case disagreements between a superblock's definition of a
"container", all without thrashing the kernel.

>
>> 2a/ This simply follows in the path of the design decision to not
>> support in-kernel auto-assembly of version-1 superblocks which start=
ed
>> the requirement to use an initramfs to boot software raid. =A0(this =
is a
>> not so elegant aspect because it mandates an initramfs to boot, but =
I
>> don't think a general purpose distro can ever get away from that
>> requirement).
>
> I'm fine with needing mdadm to assemble the device. =A0I'm not fine w=
ith
> needing mdmon once it's assembled.
>
>> I will say that needing to touch several software packages (kernel,
>> initramfs, initscripts, mdadm) to get imsm superblock support has
>> added some excitement to the process in the short term. =A0Long term=
 I
>> think the elegant aspects of the decision will prove their worth.
>
> I will say that needing to touch multiple software packages might not=
 be
> a bad thing, but think of *how* they had to be changed. =A0We had to =
add
> special exceptions for mdmon all over the place: kernel scheduler (fo=
r
> suspend/resume, mdmon can't be frozen like the rest of user space or
> else writing our suspend to disk image doesn't work), initramfs,
> initscripts after initramfs, initscripts on halt, SELinux. =A0In all =
these
> cases, we had to take something that we want to keep simple and add
> special case rules and exceptions for mdmon. =A0That pretty solidly s=
ays
> that while this arrangement may have been elegant for *you*, it was n=
ot
> elegant in the overall grand scheme of things.

No, nothing elegant about that, but I think you would agree this isn't
something we threw over the wall and walked away from.  Making mdmon
more convenient to handle is hopefully an obvious priority.  Yes, I
know you would like to see it die, but we are where we are.

>
> What would have been smart was to leave array creation, assembly,
> verfication, and modification to user space, but to put *all* of the
> raid mechanics, including superblock clean/dirty state processing and
> array shut down capabilities, in the kernel. =A0Had you done that, I =
would
> have called your solution elegant.
>
> It's at this point that I feel obliged to mention that, in terms of t=
his
> whole big argument, the incremental map file has at least some amount=
 of
> sense belonging in /dev, it's really the mdmon .pid and .sock files t=
hat
> don't, and those files wouldn't even exist had you designed things as=
 I
> mention here. =A0It's the fact that you have two files per device tha=
t you
> should be placing in a specific place on the filesystem in order for
> them to be useful and adhere to standards yet the program they belong=
 to
> needs to exist outside the context of any filesystem that I think is
> pretty strong evidence of the inelegance of this design.
>

This comment makes me see Neil's argument in a different light,
(hopefully I am not mischaracterizing it), but essentially we are
waiting for the standards to catch up with this new class of program.
=46USE, CUSE, and mdmon belong to a class of programs that move
traditionally exclusive kernel space functionality to userspace.
Debian's /lib/init/rw looks to be a response to this grey area of the
standards (not that I have any familiarity with the LSB).

--
Dan
