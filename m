From: Lucas Barbuto <lucas@qk.com.au>
Subject: Re: Order of RAID creation in boot process
Date: Thu, 30 Jan 2003 13:25:20 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030130022520.GA1931@qk.com.au>
References: <20030129074954.GA30915@qk.com.au> <3E37913D.8070005@ratnet.stw.uni-erlangen.de>
Reply-To: Lucas Barbuto <lucas@qk.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E37913D.8070005@ratnet.stw.uni-erlangen.de>
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Norman,

Thanks for continuing to try to help me out, I was really floundering
there for a while.  I've sorted things out now.  I've put my system
disks back in the primary and secondary IDE slots and I'm going to use
the ataraid slots for non-OS disks.

I've got a software RAID-0 going over hda and hdc, I'm booting off it,
I've got my root partition on it and I've got a combination of ext3 for
the root and boot partitions and XFS for the rest.

I accomplished this by installing onto hda, then creating the raid
devices across hda and hdc one by one and using the failed-disk
directive and a boot disk to make the root partition a raid device.  All
standard stuff.

I've removed the ataraid and pdcraid code from the kernel and compiled
it as modules, with this setup, the md devices are created before the
root file system is mounted.  I still don't really understand why they
aren't created first when ataraid and pdcraid are compiled in.  I guess
there is a conflict there?  I can now access hde and hdg by loading the
module after the system has booted, this will work out fine for me as
those drives will now just be used to store non-OS data (backups and
stuff).

Again, thanks for your help.

Regards,

Lucas
