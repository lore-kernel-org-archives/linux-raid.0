From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 001 of 6] md: Send online/offline uevents when an md array
 starts/stops.
Date: Thu, 09 Nov 2006 13:10:28 +0300
Message-ID: <4552FE94.20400@tls.msk.ru>
References: <20061031164814.4884.patches@notabene>	<1061031060046.5034@suse.de>	<20061031211615.GC21597@suse.de>	<3ae72650611020413q797cf62co66f76b058a57104b@mail.gmail.com>	<17737.58737.398441.111674@cse.unsw.edu.au>	<1162475516.7210.32.camel@pim.off.vrfy.org>	<17738.59486.140951.821033@cse.unsw.edu.au>	<1162542178.14310.26.camel@pim.off.vrfy.org>	<17742.32612.870346.954568@cse.unsw.edu.au>	<Pine.LNX.4.64.0611060030320.20361@twinlark.arctic.org> <17744.5139.805134.577609@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17744.5139.805134.577609@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: dean gaudet <dean@arctic.org>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
[/dev/mdx...]
>> (much like how /dev/ptmx is used to create /dev/pts/N entries.)
[]
> I have the following patch sitting in my patch queue (since about
> March).
> It does what you suggest via /sys/module/md-mod/parameters/MAGIC_FILE
> which is the only md-specific part of the /sys namespace that I could
> find.
> 
> However I'm not at all convinced that it is a good idea.  I would much
> rather have mdadm control device naming than leave it up to udev.

This is again the same "device naming" question as pops up every time
someone mentions udev.  And as usual, I'm suggesting the following, which
should - hopefully - make everyone happy:

  create kernel names *always*, be it /dev/mdN or /dev/sdF or whatever,
  so that things like /proc/partitions, /proc/mdstat etc will be useful.
  For this, the ideal solution - IMHO - is to have mini-devfs-like filesystem
  mounted as /dev, so that it is possible to have "bare" names without any
  help from any external programs like udev, but I don't want to start another
  flamewar here, esp. since it's off-topic to *this* discussion.
  Note /dev/mdN is as good as /dev/md/N - because there are only a few active
  devices wich appear in /dev, there's no "risk" to have "too many" files in
  /dev, hence no need to put them into subdirs like /dev/md/, /dev/sd/ etc.

  if so desired, create *symlinks* at /dev with appropriate user-controlled
  names to those official kernel device nodes.  Be it like /dev/disk/by-label/
  or /dev/cdrom0 or whatever.
  The links can be created by mdadm, OR by udev - in this case, it's really
  irrelevant.  Udev rules does a good job of creating /dev/disk/ hierarchy
  already, and that seems to be sufficient - i see no reason to make other
  device nodes (symlinks) by mdadm.

By the way, unlike /dev/sdE and /dev/hdF entries, /dev/mdN nodes are pretty
stable.  Even if scsi disks gets reordered, mdadm finds the component devices
by UUID (if DEVICE partitions is given in config file), and you have /dev/md1
pointing to the same "logical partition" (have the same filesystem or data)
regardless how you shuffle your disks (IF mdadm was able to find all components
and assemble the array, anyway).  So sometimes, I use md/mdadm on systems
WITHOUT any "raided" drives, but where I suspect disk devices may change for
whatever reason - I just create raid0 "arrays" composed of a single partition
and let mdadm to find them in /dev/sd* and to assemble stable-numbered /dev/mdN
devices - without any help of udev or anything else (I for one dislike udev for
several reasons).

> An in any case, we have the semantic that opening an md device-file
> creates the device, and we cannot get rid of that semantic without a
> lot of warning and a lot of pain.  And adding a new semantic isn't
> really going to help.

I don't think so.  With new semantic in place, we've two options (provided
current semantics stays, and I don't see a strong reason why it should be
removed except of the bloat):

 a) with new mdadm utilizing new semantics, there's nothing to change in udev --
    it will all Just Work, by mdadm opening /dev/md-control-node (how it's called)
    and assembling devices using that, and during assemble, udev will receive proper
    events about new "disks" appearing and will handle that as usual.

 b) without new mdadm, it will work as before (now).  And in this case, let's not
    send any udev events, as mdadm already created the nodes etc.

So if a user wants neat and nice md/udev integration, the way to go is case "a".
If it's not required, either case will do.

Sure, eventually, long term, support for case "b" can be removed.  Or not - depending
on how the things will be implemented, because when done properly, both cases will
call the same routine(s), but case "b" will just skip sending uevents, so ioctl handlers
becomes two- or one-liners (two in case a and one in case b), which isn't bloat really ;)

/mjt
