From: Omri Schwarz <ocschwar@MIT.EDU>
Subject: Re: Using the md driver to look at a bad hardware RAID.
Date: Tue, 01 Mar 2005 18:54:51 -0500
Message-ID: <200503012354.j21Nspod001357@mint-square.mit.edu>
References: <200503012327.j21NR7512050@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: Your message of "Tue, 01 Mar 2005 18:27:02 EST."
             <200503012327.j21NR7512050@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Omri Schwarz' <ocschwar@MIT.EDU>, linux-raid@vger.kernel.orgocschwar@MIT.EDU
List-Id: linux-raid.ids

> It is a 7 drive array.  If you use 6 of 7 drives, md will not try to
> re-sync.  But I have no idea if how to re-use the previous RAID data.
> 

If you mean the previous configuration, I have it on 
a writing pad and will gladly type it into a raidtab or 
mdadm incantation. 

mdadm doesn't look like it will do it yet because --assemble 
only works for devices with Linux RAID superblocks, --build
won't do RAID 5, and --create, according to the manual page, 
says "--readonly" is not supported, and will create superblocks.
Otherwise I would do the command below:

mdadm --create /dev/md0 --level=5 --raid-devices=7  \
  /dev/sdg /dev/sdf /dev/sde /dev/sdd /dev/sdc /dev/sdb missing 


Instead, if I were to insert this raidtab, would it do the right thing?

raiddev /dev/md0
	raid-level	5
	persistent-superblock	0
	nr-raid-disks	7
	parity-algorithm left-symmetric	
	device /dev/sda
	failed-disk 6
	device /dev/sdb
	raid-disk 5 
	device /dev/sdc
	raid-disk 4 
	device /dev/sdd
	raid-disk 3 
	device /dev/sde
	raid-disk 2 
	device /dev/sdf
	raid-disk 1 
	device /dev/sdg
	raid-disk 0 





> 

