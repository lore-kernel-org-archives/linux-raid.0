From: "Michael" <michael@insulin-pumpers.org>
Subject: Boot+Root+Raid+Lilo howto
Date: Mon, 27 Oct 2003 16:03:06 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310280003.h9S031205132@bzs.org>
References: <200310272311.19232.dusty@strike.wu-wien.ac.at>
Reply-To: michael@insulin-pumpers.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <200310280002.38968.maarten@vbvb.nl>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Monday 27 October 2003 23:11, Hermann Himmelbauer wrote:
> > On Monday 27 October 2003 17:00, Paul Clements wrote:
> > > Don Jessup wrote:
> 
> 
> > BTW, assuming I have md.o not as module but statically in the kernel, which
> > bootloader would support RAID1? I heard LlLO does this job but does also
> > grub - which I prefer - support Linux SW-RAID1?
> >
> > What about RAID5? Is there any bootloader that supports it?
> 
> It has been a while since I read it, but doesn't the
> Boot+Root+Raid+Lilo howto [google] go into those setups ?  It helped
> me a lot at the time...
> 
> A related question:  There are a lot of old and deprecated Raid
> howto's floating around the net, even about the antique version 0.4.
>  Is there no mechanism that gets these (very confusing for a
> newbie!) old versions removed or upgraded ?  And is this
> Boot+Root+Raid+Lilo howto I mentioned deprecated, or not ? Shouldn't
> it be integrated into the 'official' Raid howto ? (Or at least,
> there could be links to each other in the howtos) 
> 
> Greetings,
> Maarten
> 

The obsolete Root-Raid-HOWTO, covers all you need to know about 
booting raid using initrd -- that used to be the only way you could 
do it.

I'm the author of  Boot+Root+Raid+Lilo and the answer to your first 
question is yes... and ... no.

The howto is up to date with respect to how booting occurs and what 
is necessary to get disks of various geometries to work when they are 
not the same or when the motherboard bios does not automatically 
switch to the next numeric device when the first hard drive will not 
boot. It does not cover using the newer LILO which does not require 
specifying the geometries, but then it will not deal with those 
exceptions either. Everything in Boot+Root+Raid+Lilo works for the 
new LILO just fine, it just doesn't mention the easier setup which in 
my opinion only covers a small number of the boot requirements. i.e. 
Current HOWTO is far more comprehensive and I still recommend 
multiple lilo.conf files -- one for each boot drive. That way it's 
always correct, even for the corner conditions.

And.... no, I've not updated it in some time but there really isn't 
anything new.

Michael Robinton
Michael@Insulin-Pumpers.org
