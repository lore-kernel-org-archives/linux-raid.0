From: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Mon, 8 Feb 2010 15:23:07 +1100
Message-ID: <20100208152307.4afbc03d@notabene.brown>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	<1263242294-5353-3-git-send-email-dledford@redhat.com>
	<20100119110930.107ca42e@notabene>
	<4B55F138.7060008@redhat.com>
	<20100204174009.6072ec07@notabene.brown>
	<4B6B15B3.8030205@redhat.com>
	<e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
	<4B6DAC06.6060909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6DAC06.6060909-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin f krafft <madduck-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

On Sat, 06 Feb 2010 12:51:02 -0500
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> I will say that needing to touch multiple software packages might not be
> a bad thing, but think of *how* they had to be changed.  We had to add
> special exceptions for mdmon all over the place: kernel scheduler (for
> suspend/resume, mdmon can't be frozen like the rest of user space or
> else writing our suspend to disk image doesn't work), initramfs,
> initscripts after initramfs, initscripts on halt, SELinux.  In all these
> cases, we had to take something that we want to keep simple and add
> special case rules and exceptions for mdmon.  That pretty solidly says
> that while this arrangement may have been elegant for *you*, it was not
> elegant in the overall grand scheme of things.
> 

or it just means we are breaking new ground :-)

The suspend/resume issue you bring up is an important one and to my mind is
currently unsolved.

Based on my limited understanding of hibernation, I think that mdmon should
be to quiesce (but not actually be frozen) prior to taking the in-memory
snapshot, then thawed prior to writing that snapshot out to disk.
Further when it is thawed after resume-from-disk it needs to know it has been
thawed so it can check the metadata on-disk to see if any failure happened
while it slept.

Similar thing would be needed for suspend through fuse.

Do you know exactly what was done to the scheduler in redhat?

NeilBrown
