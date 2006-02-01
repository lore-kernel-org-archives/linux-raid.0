From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Fw: Re: Configuring combination of RAID-1 RAID-5
Date: Wed, 1 Feb 2006 18:16:45 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0602011805150.3632@lion.drogon.net>
References: <20060131163248.M20133@mail.uadec.mx>
 <Pine.LNX.4.56.0601311658220.17400@lion.drogon.net> <20060131165932.M47478@mail.uadec.mx>
 <Pine.LNX.4.56.0601311720010.17400@lion.drogon.net> <20060201174154.M26811@mail.uadec.mx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060201174154.M26811@mail.uadec.mx>
Sender: linux-raid-owner@vger.kernel.org
To: Enrique Garcia Briones <egarcia@mail.uadec.mx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 1 Feb 2006, Enrique Garcia Briones wrote:

> > I'd be tempted to remove the A1000 and install on the 2 internal
> > drives, then once that's happy, plug the A1000 back in again. It
> > might be that the OBP (Open Boot Prom) code is favouring the
> > external device to boot off, but it's been a very long time since
> > I've dabbled in that. You'd need to push Stop+A at boot time then
> > enter some runes at the OK prompt to check/reconfigure the boot device.
> >
> I already did that, and modify the boot_device to the first of the internal
> hard drives, but, when the Linux tries to came up, it shows an error... that
> I cannot remember now. :S

Oops....

> > The A1000 devices I've used had an on-board RAID controller and some
> > software that ran under Solaris to configure it, so that might be
> > somethign to look into too - to make sure it's doing what you expect
> > it to be doing.
>
> The raid controler that you are mentioning is possible to configure it under
> Solaris and still have it working with debian??

There are utilities to do this under Solaris - I did this many moons ago
(but then used it under Solaris) AIUI, the box looked like one SCSI device
with the RAID units appearing as LUNs. (I had the boxes populated with 3
RAID-5 arrays running over 4 disks each) I'd hope you could set it to jsut
look like 12 disks, but as theres only one SCSI cable going into it, don't
exect stellar performance. (I recall it was dog-slow anyway, but that
might just have been Slowaris ;-)

I also recall something about the Debian servers running with one of these
devices once upon a time - maybe there's someone on the Debian lists who
can help with the device & configuring?

> I was unable to find any good enough documentation regarding the
> configuration of raid-6, under debian linux, or similar, I feel like I am
> shipwrecked, can anyone aimed me to the correct direction?

List archives :-) but setting it up is easy... You need a recent 2.6
kernel and mdadm 1.8 or greater (maybe 1.9) there is nothing fancy in the
mdadm command line:

  mdadm --create /dev/md1 --raid-disks=12 --level=6 	\
	/dev/sd{a,b,c,d,e,f,g,h,i,j,k,l}1

modify to suit...

Then wait.. and wait.. for it to sync..

  watch -n2 cat /proc/mdstat

Although like all the other raid levels, it's ready to use right away,
just might not survive losing a disk very well until the entire array is
synced up.

Gordon
