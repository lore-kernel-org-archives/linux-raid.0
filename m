From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Force parity resync on raid5?
Date: Tue, 10 Aug 2004 10:04:23 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408100958470.1665@lion.drogon.net>
References: <4118046A.1070002@corp.texas.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4118046A.1070002@corp.texas.net>
To: Philip Molter <philip@corp.texas.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Aug 2004, Philip Molter wrote:

> How do I force a parity resync on a raid5 array?  Under 2.4, I would do
> this by hard cycling the box and when it came back up, it would
> automatically resync the array.  Under 2.6, this appears to have gone away.

I don't know about 2.6, (still living with 2.4) but can't you simply do:

  raidhotremove /dev/mdX /dev/hdYZ

followed by

  raidhotadd /dev/mdX /dev/hdYZ

or /dev/sdYZ if SCSI disks...

However, picking the right disk to remove might be tricky... And if you
were at all unsure about data on the disks, maybe rebooting and doing a
hard fsck of the partition(s) in maintenance mode might be a good thing
too...

Good luck!
