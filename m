From: Neil Brown <neilb@suse.de>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 10:56:01 +1100
Message-ID: <18694.21777.533214.972118@notabene.brown>
References: <18692.62860.863118.727187@notabene.brown>
	<20081027082257.GB1801@piper.oerlikon.madduck.net>
	<18694.17044.342920.841232@notabene.brown>
	<ac3eb2510810271551q53c27fedi9d662a36bd281ed4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kay Sievers on Monday October 27
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: martin f krafft <madduck@debian.org>, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Monday October 27, kay.sievers@vrfy.org wrote:
> On Mon, Oct 27, 2008 at 23:37, Neil Brown <neilb@suse.de> wrote:
> > On Monday October 27, madduck@debian.org wrote:
> >> also sprach Neil Brown <neilb@suse.de> [2008.10.26.2356 +0100]:
> 
> >> I would really like to have a clear separation of competencies.
> >> Ideally, mdadm never creates any devices but leaves it all to udev,
> >> and all configuration about alternate names ("symlinks") is done in
> >> the udev rules file.
> >
> > Yes, I am moving towards this.  And it seems to be an idea with
> > resounding support judging by the follow-ups.  So I will probably go
> > even further than I was planning.
> >  - if mdadm detects that udev is active (how do I do that???)
> 
> Most tools just check if /dev/.udev/ exists.

So we are checking if udev is configured rather than if it is
running.  I guess that is what we really want to check.  OK - thanks.

> > However I do want to move towards using sysfs preferentially,
> > particularly for "mdadm --monitor".  I would rather that daemon didn't
> > ever open the device, as that can interfere with e.g. stopping the
> > array.  The "mdadm -D" calls from udev also need to not open the device.
> 
> Sounds fine, but remember that udev will always look at every device's
> content if not explicitly told no to do. It will look for filesystem
> signatures and other metadata at the beginning and the end of the
> device.

Ahh yes, of course.
So if I want to be able to stop an array immediately after starting
(or changing) it (as I often do in test scripts, but may not need to
in real life) I need to wait for udev to settle.
So if I just need this in a script I can add
    udevadm settle
somewhere between the 'start' and the 'stop'.

I wonder if I ever want mdadm to call that directly?  I suspect that
if it got called from a udev rule it would deadlock, so I'd need to be
careful of that.

> 
> > One issue that looms in my mind as I consider this is the Usage of
> > mdadm when e.g. creating an array
> >
> >   mdadm -C /dev/md5 -l5 -n3 /dev/sd[bcd]
> >
> > I need to give the name of an array device (/dev/md5) that may not
> > exist but that mdadm doesn't now want to create.
> >
> > Once I have created the array I might want to look at the details with
> >
> >   mdadm --detail /dev/md5
> >
> > The important role that the string "/dev/md5" is serving here is
> > providing a connection between the two command.  Whatever I created in
> > the first is what I access in the second.
> 
> Can't you just use the major/minor is there is no other meaningful
> name? The devnum can not change on any system, and is always valid as
> long as the kernel device exists.

Maybe.  Though in general I would rather that the user didn't allocate
the minor number.
I could get "mdadm --create" to report
   mdadm: created array as /dev/md42
or
   mdadm: created md array 42

and then you could simply
   mdadm --detail 42

however that would be awkward for scripts.

I don't need to require that a name be given, but I want to allow it.
An I need to stay at least a little bit compatible with current mdadm
usage and practices.

I'm definitely considering allowing

  mdadm --create md0 ....

(i.e. drop the '/dev/').  That isn't a big step in functionality, but
it might be an important step in perceptions.

Thanks, the picture is slowly becoming clearer.
NeilBrown
