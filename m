From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: PROBLEM: software RAID breakage under 2.6.1-mm4
Date: Sun, 18 Jan 2004 09:25:45 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16393.46697.630398.566295@notabene.cse.unsw.edu.au>
References: <Pine.GSO.4.58.0401171318560.10877@denali.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jim Faulkner on Saturday January 17
To: Jim Faulkner <jfaulkne@ccs.neu.edu>
Cc: linux-raid@vger.kernel.org, akpm@osdl.org
List-Id: linux-raid.ids

On Saturday January 17, jfaulkne@ccs.neu.edu wrote:
> 
> I have what is probably a weird RAID setup.  I have one plain RAID-0
> array (/dev/md1), one plain linear array (/dev/md0), and another RAID-0
> array (/dev/md2) consisting of a disk and the linear array.
> 
> It appears that what is happening is that linux tries to initialize
> /dev/md2 before /dev/md0 is fully initialized.  Of course, since
> /dev/md0 doesn't exist yet, linux says "too few disks (1 of 2) -
> aborting!"

I don't see how your configuration can have ever worked.
You appear to be using auto-detect to start your arrays.
Auto-detect will only include partitions which are of type "Linux
RAID" into an array.
A linear array is *not* a partition (of any type), so autodetect will
never try to incorporate it into an MD array.

Are you *sure* this worked before?  Using auto-detect to start the
arrays rather than "raidstart" or "mdadm" ??

NeilBrown
