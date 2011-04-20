From: NeilBrown <neilb@suse.de>
Subject: Re: debian software raid1
Date: Wed, 20 Apr 2011 11:12:39 +1000
Message-ID: <20110420111239.734ae4c1@notabene.brown>
References: <1303215166.2809.8.camel@valio>
	<BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com>
	<4DADB24F.2030300@cdf.toronto.edu>
	<20110420085148.12ac0002@notabene.brown>
	<4DAE29EA.4040306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DAE29EA.4040306@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Iordan Iordanov <iordan@cdf.toronto.edu>, Mathias =?ISO-8859-1?B?QnVy?= =?ISO-8859-1?B?6W4=?= <mathias.buren@gmail.com>, b2 <b2@playtime.bg>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 19 Apr 2011 20:33:46 -0400 Joe Landman <joe.landman@gmail.com> wrote:

> On 04/19/2011 06:51 PM, NeilBrown wrote:
> > On Tue, 19 Apr 2011 12:03:27 -0400 Iordan Iordanov<iordan@cdf.toronto.edu>
> 
> [...]
> 
> > If there was such a deadlock, it would be a serious bug.   I don't believe
> > such a bug exists (but hey - I keep finding bugs in this code, when I'm not
> > busy writing new bugs, so I guess it could crash you machine and kill your
> > cat).
> 
> I ran into this a few years ago (early 2.6 series, maybe 2.6.15 or so). 
>   Some sort of race condition.  Required a reset to get the machines 
> attention.  

I wonder what this might have been...
Resume from suspend when swap in on md/raid can be a bit tricky and may not
have been well tested at that time.  You need to be able to assemble the
RAID1 for read without writing anything.  That can be done now by setting the
'start_ro' module parameter (echo 1
> /sys/modules/md_mod/parameters/start_ro).

I haven't actually tested it myself though so I cannot speak from experience.

>               Haven't tried since.  Since we do lots of MD raid, I 
> generally either put the swap on hardware RAID, or stripe it and 
> sometimes hope for the best.  The latter doesn't always work.  When a 
> drive goes pear shaped, and takes down pages with it, your machine will 
> crash, and pretty hard at that.
> 
> We'll definitely try the swap atop MD RAID going forward.  I like the 
> idea of a RAID10 for it.
> 
> >> It would be nice to have a discussion among people who have experience
> >> with all of this.
> >
> > Definitely put swap on RAID1 if you have RAID1 at all.
> >
> > My personal preference with RAID1 to to have a single RAID1 (probably
> > --metadata=1.0) across the whole devices, and partition that for root, swap,
> > home.
> 
> This gets to my question, since we haven't tried this yet ... can we do 
> whole device MD RAIDs, and boot from them?  Is there anything special we 
> need to do in their construction (use --auto=mdp or similar)?  We'd 
> really prefer to go this route rather than building multiple smaller 
> RAIDs.  We can manage the latter, but the former is far easier/cleaner 
> to handle rebuilds with.

The little 'server' in my garage runs md/raid1 across two device (using 0.90
metadata - never had any reason to convert).

I seem to remember that I had to do something special to grub to get it to
boot initially, but I also vaguely remember that after some series of updates
(this is Debian) it seemed to get a lot easier.  My "grub.cfg" contains:

menuentry 'Debian GNU/Linux, with Linux 2.6.32-5-686' --class debian --class gnu-linux --class gnu --class os {
        insmod raid
        insmod mdraid
        insmod part_msdos
        insmod ext2
        set root='(md0,1)'
        search --no-floppy --fs-uuid --set 03e9951f-d174-4d88-9b4c-dd7a31c0de61
        echo    'Loading Linux 2.6.32-5-686 ...'
        linux   /vmlinuz-2.6.32-5-686 root=UUID=6e8a3564-5588-476e-bbe5-a68c967c6c8e ro  quiet
        echo    'Loading initial ramdisk ...'
        initrd  /initrd.img-2.6.32-5-686
}

which was all automatically created, and it seems to "just work".

So yes - you can boot for partitioned whole-device md/raid.
You might need to use a "metadata-at-the-end" format list 0.90 or 1.0, but it
is entirely possible that it will work for other metadata formats, I really
don't know.  Other than that, no special options needed when creating the
array.

NeilBrown
