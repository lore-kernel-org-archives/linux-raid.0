From: Neil Brown <neilb@suse.de>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Tue, 9 Feb 2010 08:38:38 +1100
Message-ID: <20100209083838.6568cac0@notabene.brown>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	<1263242294-5353-3-git-send-email-dledford@redhat.com>
	<20100119110930.107ca42e@notabene>
	<4B55F138.7060008@redhat.com>
	<20100204174009.6072ec07@notabene.brown>
	<4B6B15B3.8030205@redhat.com>
	<e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
	<4B6DAC06.6060909@redhat.com>
	<e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>
	<4B702EA5.3030103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B702EA5.3030103@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, initramfs@vger.kernel.org, martin f krafft <madduck@debian.org>, Michal Marek <mmarek@suse.de>, Hans de Goede <hdegoede@redhat.com>, Bill Nottingham <notting@redhat.com>
List-Id: linux-raid.ids

On Mon, 08 Feb 2010 10:32:53 -0500
Doug Ledford <dledford@redhat.com> wrote:

> On 02/06/2010 04:07 PM, Dan Williams wrote:
> 
> > This comment makes me see Neil's argument in a different light,
> > (hopefully I am not mischaracterizing it), but essentially we are
> > waiting for the standards to catch up with this new class of program.
> > FUSE, CUSE, and mdmon belong to a class of programs that move
> > traditionally exclusive kernel space functionality to userspace.
> > Debian's /lib/init/rw looks to be a response to this grey area of the
> > standards (not that I have any familiarity with the LSB).
> 
> So if we want to argue that the standards are simply behind the times,
> and we need to do something that makes sense regardless of the
> standards, then I don't think anything in /dev or /lib makes sense.  The
> files that need to be created pre-rw-root are varied in their type and
> purpose between different things.  What we really need is simply an
> early boot /tmp area.  So, why not make a top level directory that
> clearly delineates this nature?  Something like /pre-init or /early-tmp
> or whatever?  Or possibly /tmp/pre-boot or /tmp/pre-init or
> /tmp/pre-pivot-root (the pre-pivot-root naming is awfully linux
> specific, so maybe /tmp/pre-init or /tmp/pre-boot would be better for
> possible standards acceptance later)?  I was thinking that mdmon's files
> would be stuck there, but then I remembered that we are doing option #3
> for mdmon, restarting after the system is up and running, so only the
> mdmon instances from the initramfs would put their files there, the
> final ones would be on the real /var/run area.  So, since as far as I
> know the mdmon .sock files were the only pre-boot files that couldn't be
> moved later (but effectively get moved by restarting mdmon after r/w
> /var/run), any and all files in /tmp/pre-pivot-root should be removed
> once the system is up and running, and quite possibly the filesystem
> could be entirely done away with.  At least then the naming would be to
> Neil's satisfaction I think, and mine.  And personally, when the
> standards are simply behind the times, I have no problem blazing ahead
> and letting them catch up when they get off their asses.
> 
> 

That's the spirit!!!
Let's figure out what we really want/need, and just do it.

Following my recent discovery that mdmon prevents /var from being unmounted
at shutdown, I wonder if we really want something generic that persists from
very early boot to very late shutdown, rather than just the early-boot part.
So something like /var/run, but not dependent on /var and guaranteed to be
in-memory (or swap) and created very early by initramfs.

   /run
???
Trivial implementation for most distros would be to make it a symlink
to /dev/run.

I would prefer a name a little more descriptive than "/run" - something that
reflects the idea that it is particularly for early-boot or late-shutdown -
but nothing comes to mind.

I could probably actually live with "/dev/run" as the permanent home for the
mdmon files:  /dev/run/mdmon/*.{sock,pid}
It addresses most of the issues I had with the original suggestion (hidden
files, non-generic approach) so the "cons" are weaker.  And I now understand
the "pros" better (races with cleaning /var/run, issues with unmounting /var
etc).

Anyone second the motion?

NeilBrown
