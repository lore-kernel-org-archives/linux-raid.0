From: google@familycook1.net
Subject: Re: no auto detection of software raid 5 on boot
Date: Fri,  7 Jan 2005 12:14:49 -0500
Message-ID: <1105118089.41dec389f1b4d@familycook1.net>
References: <1105114981.41deb765668b9@familycook1.net> <41DEBD41.201@tisnix.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DEBD41.201@tisnix.be>
Sender: linux-raid-owner@vger.kernel.org
To: wimpunk <wim-raid@tisnix.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for your very fast responce.

Can you point me in the right direction on where I can change the order of
driver installs.  I am guessing rc.sysinit, but I am not sure.

thank you
donald


Quoting wimpunk <wim-raid@tisnix.be>:

> You're trying to detect the raid before the scsi driver gets loaded.
>
> wim.
>
> google@familycook1.net wrote:
> > I am having a problem with auto detection of software raid 5.
> >
> > I can set up the the raid device, mkfs.ex3, and mount the disk; but at
> reboot
> > the raid device is not auto decteced.  After the system comes up I can do a
> > mdadm -A and the raid will assemble and then I can mount it.
> >
> > One interesting note.  I am trying to get the raid system to work on Fedora
> core
> > 2.  But if I boot a Fedora core 3 rescue CD, the raid gets auto detected.
> >
> > Any help would be very much appreciated.
> >

