From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: Extend raid 5
Date: Sun, 11 Jan 2004 18:13:35 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040112021335.GF17845@matchmail.com>
References: <1704458665.20040112011155@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1704458665.20040112011155@gmx.de>
To: buliwyf <buliwyf@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 12, 2004 at 01:11:55AM +0100, buliwyf wrote:
> Hello
> 
> I have the following problem.
> I have set up a Linux Software Raid 5 with 4 160GB Disks.
> This works well. Now i run out of Disk Space and want to add another
> 160 GB Disk on the fly. Is this possible without loosing Data?

No, the raid format splits the raid stripes sequencially between the drives
available in the array.  So adding an extra online disk would really mess up
the formatting of the array, and therefore isn't allowed.

There really isn't a way to get the redundancy of raid and the size addition
capabilities of LVM when you only want to add one disk.

If you had lvm on top of raid, you could add that one disk to your lvm set,
but it wouldn't be redundant unless you added two disks and added a raid1
array to your lvm set.

I'd also suggest you get an extra drive as a spare for your raid5 array.

I'd suggest you add the drive as a seperate filesystem until you can setup
your array with lvm on raid.

Mike
