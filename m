From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: mdadm-grow-continue service crashing (similiar to "raid5 reshape
 is stuck" thread from May)
Date: Mon, 13 Jul 2015 17:07:07 -0500
Message-ID: <CACsGCyRkodONCAenhF9gHAShdZPP7uShJC1MHfdbZs81ho7RvA@mail.gmail.com>
References: <CACsGCySTbrEYddSNfi7+9KnxWeddkBGDbxTsBSJkkvGHOaJwKg@mail.gmail.com>
	<55A26F65.5020703@turmel.org>
	<CACsGCyT5vgFkQEc1zgKCGgT_rO5V4cmuFmo9K4vwiqN4JsPLJA@mail.gmail.com>
	<55A4056C.6050004@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55A4056C.6050004@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 13, 2015 at 1:37 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> Please note that this is the DEFINED behaviour of /tmp, so it has a very
> high probability of happening.
>
> If you want temporary data to survive a reboot, put it in /var/tmp.

OK.  Looking more carefully, I see my "/tmp" partition is of type
tmpfs.  So yes, on reboot it would have been totally clean, exactly as
you say.  In my case, my /var partition was on the raid5 being
reshaped, so /var/tmp wasn't an option for me.

> Oh - and if SeLinux only lets you put it in /tmp, what happens if you
> don't have a separate /tmp partition? You can't put the  backup file on
> the partition you are rebuilding, and SeLinux won't let you put it
> anywhere else? That's a big disaster in the making ...

Well, SELinux will let you put it anywhere that is labeled to allow
it.  So if it needs to go on some folder that isn't labelled properly,
then some labeling needs to be done.  I didn't want to deal with the
(minor) hassle of creating a label, of having to understand what label
would be appropriate, so I wanted to find a folder that was already
allowed by the existing labeling.  So I tried a bunch of folders in
succession until one worked.

What is the interaction between the backup file I had to specify in
/lib/systemd/system/mdadm-grow-continue@.service and the backup file I
had to specify on the command line to do the --grow to shrink the
array?  It kind of looks like the backup file on the "mdadm" command
line doesn't really matter, except that I had to specify one, because
"mdadm --grow --raid-devices=4 /dev/md125" wouldn't *try* to start
without a backup file specified, but then just crashed in the
mdadm-grow-continue service.  Specifying a (different) backup file
there and restarting the service got the reshape to complete.

This raises a big question with SELinux.  When a backup file is truly
needed, mdadm needs the ability to write the backup file to more than
one partition (not at a time, but in general), depending on which raid
device is being modified.  This means that some custom labeling may
need to be done either in advance to prepare for recovery or
on-the-fly in a recovery situation.

             Eddie
