From: Gordon Henderson <gordon@drogon.net>
Subject: Re: New RAID array syncs very slow
Date: Tue, 23 Mar 2004 22:37:20 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0403232235270.13470@lion.drogon.net>
References: <40602BE7.8080705@oddpost.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40602BE7.8080705@oddpost.com>
To: Jay Roberts <roberts@oddpost.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 23 Mar 2004, Jay Roberts wrote:

> I just set up a new Raid5 array using 4 200GB disks on 2 controllers. I
> created the array, and it begins to sync up, but it will not sync at
> over 600Kb. It has been over 12 hours now, and the sync is only 7% done.
> >From reading, I know that sync should only take a few hours, but at the
> current rate mine will take 91 hours which seems like an insane amount
> of time. I am looking for any advice on this.  Details follow:

You probably don't have DMA enabled on the controller. See what

  hdparm /dev/hde

and for all the other drives you have gives.

Do a crude speed test with

  hdparm -Tt /dev/hde

too. You ought to get at least 45MB/sec on a modern IDE drive.

You might have to build a custom kernel to get the right driver for the
chipset.

Gordon
