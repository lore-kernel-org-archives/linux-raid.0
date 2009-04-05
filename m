From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 17:03:10 -0500
Message-ID: <20090405220311.YMPW19140.cdptpa-omta03.mail.rr.com@Leslie>
References: <87f94c370904051300x531acb1fqb55319536333c01f@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370904051300x531acb1fqb55319536333c01f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I for one think it is very reasonable that Leslie may have experienced
> numerous different problems in the course of trying to put together a
> large scale raid system for video editing.

I've encountered much worse, with many more failure sources.

> But Leslie, maybe you do need to take a step back and review your
> overall design and see what major changes you could make that might
> help.

That's a reasonable solution, but until I know more of where the fundamental
issue actually lies, any changes I make may be a waste of time.  What if
it's a power supply issue?  A bad cable?  What if the new RAID chassis is
also bad?  What if it's a motherboard problem?  I can't afford to replace
the entire system, and even if I did, is the issue due to a one off
component failure or a systemic problem with the entire product line (i.e.
do I replace the component with the same model or a different piece of
equipment altogether? 

> I'm not really keeping up with things like video editing, but as
> someone else said XFS was specifically designed for that type of
> workload.  It even has a psuedo realtime capability to ensure you
> maintain your frame rate, etc.  Or so I understand.  I've never used
> that feature.  You could also evaluate the different i/o elevators.

I'll look into XFS.  Of course, it means taking the system down for several
days while I reconfigure and then copy all the data back.  It also makes me
really nervous to only have only one or two copies of the files in
existence.  When the array is reformatted, the bulk of the data only exists
in one place: the backup server.  Three days is a long time, and it's always
possible the backup server could fail.  In fact, the last time I took down
the RAID server, the backup server *DID* fail.  It's motherboard fried
itself and took the power supply with it.  Fortunately, the LVM was not
corrupted, and all that was lost were the files in the process of being
written to the backup server (which of course was then the main server for
the time being).

As to the file system, it really doesn't make a lot of different at the
application layer.  The video editor is on a Windows (puke!) machine and
only needs a steady stream of bits across a SAMBA share.  Similarly, the
server does not stream video directly.  It merely transfers the file -
possibly filtering through ffmpeg first - to the hard drive of the video
display devices (TiVo DVRs), where at some point the file is streamed out
the video device.  As long as the array can transfer at rates greater than
20 Mbps, everything is fine as far as the video is concerned.

> If I were designing a system like you have for myself, I would get one
> of the major supported server distros.  (I'm a SuSE fan, so I would go
> with SLES, but I assume others are good as well.)  Then I would get

Debian is pretty well supported, and to my eye has consistently the most
bug-free distros, including the commercial distros.  Of course I am not an
expert in this area, but I have worked some with Xandros and Red Hat.
Personally, I much prefer Debian.  This is the first time I have run into an
issue which I could not resolve myself.  Of course, I've only been using
Linux at all since 2002, and I've only had desktop Linux systems for about 4
years, so my experience is not extensive.

> hardware they specifically support and I would use their best practice
> configs.  Neil Brown has a suse email address, maybe he can tell you
> where to find some suse supported config documents, etc.

I don't think I can afford that.  Things are extremely tight right now, and
a whole hog hardware replacement is really not practical.  Although it is
entirely possible this could be related to a number of hardware and software
components, I'm really hoping it is not the case, and if I can pinpoint the
problem through diagnosis and then replace a single element, I think it is
what needs to be done.  That said, if this is due to a hard drive problem -
one or many - the hard drives are due to be replaced after the 3T drives are
shipping anyway, so if one or more drive are the problem, it should go away
at that time.  If not, then it would be better to find and fix the problem
prior to that time.

> Ext4 is claimed "production" but is getting major corruption bugzillas
> (and associated patches) weekly.  I for one would not use it for
> production work.

Uh, yeah.  I was unaware of XFS until today, but I did look at Ext4.  One
look and I said, "Uh-uh".

> Tejun Heo is the core eSata developer and he says not to trust any
> eSata cable a meter or longer.  ie. He had lots of spurious
> transmission errors when testing with longer cables.

Just FYI, the eSATA cables going to the array chassis are 24", and I believe
them to be of high quality.  They have also been replaced with no apparent
effect.

> Lot of reported problems turn out to be power supplies not designed to
> carry a Sata load.  Apparently sata drives are very demanding and many
> "good" power supplies don't cut the mustard.

Well, the server itself only has a single PATA drive as its boot drive, and
the only peripheral card is the SATA controller.  It's a new chassis (6
months) with a 550 Watt supply, so it's unlikely to be the culprit, even
though the CPU is 125 Watts.  The RAID chassis is a 12 slot system with a
400 Watt supply and 11 drives.  I suppose I could try changing the RAID
supply to a 600 or 700 watt model, but really 400W should be enough for 11
drives and 3 port multipliers.  According to the spec sheets, the most power
hungry drives in the mix (Hitachi E7K1000) require an absolute maximum of 26
watts.  If all the drives were the same, that would be 286 watts.
Especially given the Western Digital drives and the one Seagate (not part of
the array) drives are specified to have somewhat lower power consumption,
400W should be fine.

