From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Terrible slow write speed to MegaRAID SCSI array
Date: Sat, 18 Mar 2006 11:02:07 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0603181059480.2734@chaos.egr.duke.edu>
References: <441BE719.1010308@tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <441BE719.1010308@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 18 Mar 2006 at 1:55pm, Michael Tokarev wrote

> We've installed an LSI Logic MegaRaid SCSI 320-1 card
> on our server (used only temporarily to move data to
> larger disks, but that's not the point), and measured
> linear write performance, just to know how much time
> it will took to copy our (somewhat large) data to the
> new array.  And to my surprize, this card, with current
> firmware, current (2.6.15) kernel and modern disks is
> terrible slow on writing - writing speed varies between
> 1.5 megabutes/sec to 10 megabytes/sec, depending on the
> logical drive settings in the megaraid adapter.

I've got the same card in a server running CentOS 4.2.  With default 
settings on the card and the OS, I'm getting 45MB/s reads and 22MB/s 
writes according to bonnie++ to a 2 disk raid1 mirror.  I'll certainly try 
to get better, but it's not nearly as bad as yours.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
