From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
	support handoff after pivotroot
Date: Thu, 4 Feb 2010 16:04:37 -0700
Message-ID: <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	 <1263242294-5353-3-git-send-email-dledford@redhat.com>
	 <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>
	 <20100204174009.6072ec07@notabene.brown> <4B6B15B3.8030205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6B15B3.8030205-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin f krafft <madduck-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

On Thu, Feb 4, 2010 at 11:45 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> To be fair, if post-hoc versus initial made any difference what so ev=
er,
> then so would the fact that I wouldn't have chosen to have these file=
s
> exist at all. =A0I would have made incremental assembly work without =
a map
> file and I would have made imsm superblock handling be in the kernel.
> So, I'm dealing with the consequences of decisions I didn't make and
> wouldn't have made. =A0I don't think it's then fair to put some sort =
of
> 'premeditated' versus 'dealing with the situation' bias on my respons=
e.

On the argument about where to place the mdmon files I am now torn
between the "Neil" and "Doug" positions, but on the decision of where
to place imsm superblock handling I stand behind the design decision
to put it in userspace.

1/ If you take a look at native md superblock support you see that the
support code is duplicated between kernel-space and user space, having
it all handled in userspace means only one code base to maintain
(elegant aspect #1).

2/ The kernel can simply worry about the *mechanism* of providing raid
while all the assembly *policy* and support for any number of
superblock formats is relegated to where policy belongs (elegant
aspect #2).

2a/ This simply follows in the path of the design decision to not
support in-kernel auto-assembly of version-1 superblocks which started
the requirement to use an initramfs to boot software raid.  (this is a
not so elegant aspect because it mandates an initramfs to boot, but I
don't think a general purpose distro can ever get away from that
requirement).

I will say that needing to touch several software packages (kernel,
initramfs, initscripts, mdadm) to get imsm superblock support has
added some excitement to the process in the short term.  Long term I
think the elegant aspects of the decision will prove their worth.

--
Dan
