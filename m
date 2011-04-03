From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 5 Array
Date: Sun, 3 Apr 2011 21:01:38 +1000
Message-ID: <20110403210138.584c796c@notabene.brown>
References: <BANLkTim8620MUckc+EVCWo9FCTs=65_p8Q@mail.gmail.com>
	<4D977279.30107@gmail.com>
	<BANLkTimJfUhvkpkkAH=NLJOvLL-Jotrwqg@mail.gmail.com>
	<4D97828C.8050806@gmail.com>
	<6158157523854459259@unknownmsgid>
	<20110403040113.472838d4@natsu>
	<AANLkTikJtFb0JtS1-Je9NFXn-CRc4pi7pmYFNV7v2SEg@mail.gmail.com>
	<BANLkTi=wWAE79KOPhZ0OUWpicgcD7QNG-g@mail.gmail.com>
	<BANLkTimRSmSu2XOfQ8yUxn5r2Tsq53LCmQ@mail.gmail.com>
	<BANLkTikQai-ZwuEDQDinMcYi4ics_axd7Q@mail.gmail.com>
	<20110403174900.38de17e2@notabene.brown>
	<BANLkTi=yTeG5-E=R6wy0GZe_iyxC5_7-Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=yTeG5-E=R6wy0GZe_iyxC5_7-Fg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus <nexuslite@gmail.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Roman Mamedov <rm@romanrm.ru>, Simon Mcnair <simonmcnair@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 3 Apr 2011 01:02:40 -0700 Marcus <nexuslite@gmail.com> wrote:

> The file system is ext4. The current raid drive is 1.5TB the old size
> was 1TB. I can create a new partition on the drive it just wont let me
> resize it to a larger size. It seems to be maxed out at 1TB for some
> reason.

What is "it"?  What command do you run?  What output does it generate?

> 
> mdstat shows 1465159552 blocks which is the new size.

Why didn't you just include the complete "cat /proc/mdstat".
That would have been much more informative.

> 
> fdisk -l shows Disk /dev/md2: 1500.3 GB, 1500323381248 bytes 2 heads,
> 4 sectors/track, 366289888 cylinders.
> 
> Current partition: /dev/md2p1              17   244191968   976767808
>  83  Linux
> 
> resize2fs -p /dev/md2 returns: nothing to do
> 

Is this "it"??  Do you realise that you need to resize the device "/dev/md2"
before you can resize the filesystem that is stored in "/dev/md2".

> Nothing is failing it just seems to be at a max size. I also tried
> resizing with parted and it seems to think 244191968 is max like
> resize2fs does.
> 


As you provided so little concrete details - despite me asking for lots -
I'll have to guess.

I guess that if you
  mdadm -S /dev/md2
  mdadm -A /dev/md2 --update=device-size /dev/...list.of.devices
  mdadm -G /dev/md2 --size=max
  resize2fs /dev/md2

then it might work.  Or maybe it'll corrupt everything.  I cannot really be
sure because I am being forced to guess.

Commands like:

  mdadm --examine /dev/*
  mdadm --detail /dev/md*
  cat /proc/partitions
  cat /proc/mdstat
  dmesg | tail -100

are the sort of things that are useful - not "I tried something and it didn't
work"...

NeilBrown

(sorry, but I get grumpy when people provide so little information).



> 
> 
> On Sun, Apr 3, 2011 at 12:49 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sat, 2 Apr 2011 23:41:50 -0700 Marcus <nexuslite@gmail.com> wrote:
> >
> >> Okay I have my raid extended to 1500.3GB however I can't seem to grow
> >> the partition past 1TB. It will let me create a new partition but it
> >> won't let me make the current partition any bigger. Does anyone know
> >> how to fix this?
> >
> > Best to show exactly the command you use, exactly the results, and details
> > about the component devices (particularly size).
> > When using any mdadm command, add "-vv" to make it as verbose as possible.
> > Include kernel log messages (e.g. dmesg | tail -100)
> >
> > Prefer to send too much info rather than not enough.
> > And just place it in-line in the email, no attachments, not 'pastebin' links.
> >
> > NeilBrown
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

