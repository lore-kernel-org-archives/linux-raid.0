From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: new array not starting
Date: Wed, 08 Nov 2006 02:12:08 +0000
Message-ID: <eiredo$mmo$1@sea.gmane.org>
References: <eirdlc$l7j$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eirdlc$l7j$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:
> 
> If I try to start the array manually:
> 
> # mdadm --assemble --auto=yes  /dev/md2 /dev/hdc /dev/hdd /dev/hde
> /dev/hdf /dev/hdg /dev/hdh /dev/hdi /dev/hdj
> mdadm: cannot open device /dev/hdc: No such file or directory
> mdadm: /dev/hdc has no superblock - assembly aborted
> 
> What's going on here? No superblock? Doesn't that get written when the
> array is created?
> 
> Am I doing this right?

SATA disks? hdc? Duh!

This worked:

# mdadm --assemble --auto=yes  /dev/md2 /dev/sdc /dev/sdd /dev/sde
/dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj
mdadm: /dev/md2 has been started with 8 drives.

However, I'm not sure why it didn't start automatically at boot. Do I
need to put it in /etc/mdadm.conf for it to star automatically? I
thought md start all arrays it found at a start up?

R.

