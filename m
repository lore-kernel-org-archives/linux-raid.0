From: Brad Dameron <brad@seatab.com>
Subject: RE: Software RAID 0+1 with mdadm.
Date: Wed, 26 Jan 2005 12:32:36 -0800
Message-ID: <1106771556.21977.1.camel@serpent>
References: <200501252302.j0PN2A904022@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501252302.j0PN2A904022@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2005-01-25 at 15:04, Guy wrote:
> For a more stable array, build a RAID0 out of 2 RAID1 arrays.
> 
> Like this:
> 
> mdadm --create /dev/md1 --level=1 --chunk=4 --raid-devices=2 /dev/sdb1
> /dev/sdc1
> mdadm --create /dev/md2 --level=1 --chunk=4 --raid-devices=2 /dev/sdd1
> /dev/sde1
> mdadm --create /dev/md0 --level=0 --chunk=4 --raid-devices=2 /dev/md1
> /dev/md2
> 
> You can put a file system directly on /dev/md0
> 
> Are all of the disks on the same cable?
> 
> Not sure about your booting issue.
> 
> Guy
> 


Ya I did this setup as well. Still the same booting issue. Once it's
booted I can run mdadm --assemble --scan and it will find just the
stripe and then add it. I saw several people having this issue on a
google search. But never any solutions.

Brad Dameron
SeaTab Software
www.seatab.com



