From: Maarten v d Berg <maarten@vbvb.nl>
Subject: Re: Extend raid 5
Date: Mon, 12 Jan 2004 10:21:08 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401121021.08498.maarten@vbvb.nl>
References: <1704458665.20040112011155@gmx.de> <20040112021335.GF17845@matchmail.com>
Reply-To: maarten@nebula.vbvb.nl
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040112021335.GF17845@matchmail.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 12 January 2004 03:13, Mike Fedyk wrote:
> On Mon, Jan 12, 2004 at 01:11:55AM +0100, buliwyf wrote:

> > I have the following problem.
> > I have set up a Linux Software Raid 5 with 4 160GB Disks.
> > This works well. Now i run out of Disk Space and want to add another
> > 160 GB Disk on the fly. Is this possible without loosing Data?
>
> No, the raid format splits the raid stripes sequencially between the drives
> available in the array.  So adding an extra online disk would really mess
> up the formatting of the array, and therefore isn't allowed.
>
> There really isn't a way to get the redundancy of raid and the size
> addition capabilities of LVM when you only want to add one disk.

[...]
> I'd suggest you add the drive as a seperate filesystem until you can setup
> your array with lvm on raid.

Hi Mike.  I read about LVM some time ago and decided to use that as it seemed 
to solve my problem of the ever-growing data volume I need to store.

However, after the initial setup I quickly dropped the LVM idea again since it 
only _seemed_ to solve my problem. As I understand it, LVM allows the 
addition of extra volumes but it does nothing at the level of the filesystem 
which resides on top. So in order to effectively grow my filesystem, which is 
the ultimate goal of course, I'd need to delete the current FS and make a new 
-bigger- one. And last time I checked this definitely kills your data.

Otherwise, adding a 40 GB physical volume to a 120 GB raid5 / LVM set just 
gives me one 120 GB partition and [room for] another 40 GB partition. 
There is NO gain whatsoever using LVM here compared to when I would just have 
added a single 40GB disk all by itself without using LVM in the first place, 
is there ?

This has always left me wondering.  Did I miss something (except using some 
alpha FS-resize code...) ?

Greetings,
Maarten

