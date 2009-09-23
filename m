From: "Sunpyo Hong" <sunpyo.hong@amac.com>
Subject: RE: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Wed, 23 Sep 2009 11:50:46 -0400
Message-ID: <200909231150891.SM02456@trainer>
References: <20090923151436.GB9409@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090923151436.GB9409@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Robin Hill' <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was also very confused because when running the --create command, none of
the disks reported that it did not contain an ext2/3 filesystem. What does
that mean? Because when I contacted WD they told me the system was an ext3
filesystem.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robin Hill
Sent: Wednesday, September 23, 2009 11:15 AM
To: linux-raid@vger.kernel.org
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.

On Wed Sep 23, 2009 at 09:56:52AM -0400, Sunpyo Hong wrote:

> I actually know the physical order of each HD. I was able to pull them out
> of the NAS in the order specified in the NAS. (Each HD enclosure was
> labeled) In the actual sata ports, this is what the hds are in.
> 
> SATA 0: HD1
> SATA 1: HD2
> SATA 2: HD3
> SATA 3: HD4
> SATA 4: CD-ROM
> 
> I think that linux reads the sata ports like.. 0 = sda, 1=sdb.. etc. So I
> assume that HD1 = /dev/sda (missing), HD2 = /dev/sdb, HD3 = /dev/sdc, HD4
=
> /dev/sdd so a create command should look like this:
> 
> #mdadm -Cv -level=5 --raid-disks=4 missing /dev/sdb4 /dev/sdc4 /dev/sdd4
> 
> This is exactly how I wrote the create command. Again I knew the physical
> order of the Raid and put them together in that order. Tell me if I'm
doing
> something wrong. 
> 
> I'll check out testdisk as well..
> 
The array order detected by the initial --assemble is (unless you have
incredibly strong reason to believe otherwise) most likely to be the
correct order, in which case the correct create command should be:
    mdadm -Cv -l 5 -n 4 /dev/sdd4 /dev/sdc4 /dev/sdb4 missing

I'd suggest re-creating the array in this order (ignoring the irrelevant
"physical" ordering) before attempting any other recovery.
Incidentally, does the --create command report that any of the disks
contain an ext2/3 filesystem? This is usually reported for one of the
drives.

However, given that the initially-assembled array failed to mount, I
suspect you're hosed, and that whatever the ShareSpace did in attempting
to rebuild the array has actually broken it completely.

Cheers,
    Robin
-- 
     ___        
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

