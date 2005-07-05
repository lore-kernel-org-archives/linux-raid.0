From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Inactive RAID5 and different states
Date: Tue, 5 Jul 2005 15:40:19 +1000
Message-ID: <17098.7491.742060.73486@cse.unsw.edu.au>
References: <200507012128.37408.01771@iha.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jacob Madsen on Friday July 1
Sender: linux-raid-owner@vger.kernel.org
To: Jacob Madsen <01771@iha.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 1, 01771@iha.dk wrote:
> Hello,
> 
> Xorg recently crashed and I was forced to reset the computer. After booting I 
> discovered that partition 'sda10' was missing from an array. I checked the 
> logs, since I suspected that 'sda' was faulty, but there was no messages 
> about 'sda' at all. So I examined the md device and sda device.
> Nothing seemed wrong as far as I could tell (its SATA, so I cant run a 
> internal diagnostic on the harddrive, since my kernel doesnt support SMART 
> for SATA), so I went on and added 'sda10' back to the array. But nothing 
> happened and the array was still marked inactive.
> I then stopped the array with 'mdadm -S /dev/md8' and got this in kernel log:
> [kernel] md: md8 stopped.
> 
> I then executed 'mdadm --assemble --scan'.
> This is the entries in /etc/mdadm.conf (two lines):
> DEVICE /dev/sda10 /dev/sdb10 /dev/sdc10 /dev/sdd10
> ARRAY /dev/md8 level=raid5 num-devices=4 
> UUID=fc549abf:0e1662f3:3b60b5c3:7a8e6fc7 
> devices=/dev/sda10,/dev/sdb10,/dev/sdc10,/dev/sdd10
> And this is from the kernel log:
> [kernel] md: bind<sda10>
> [kernel] md: bind<sdc10>
> [kernel] md: bind<sdd10>
> [kernel] md: bind<sdb10>
> [kernel] md: kicking non-fresh sda10 from array!
> [kernel] md: unbind<sda10>
> 
> Since I have no idea what is suddently wrong with 'sda10' I went on and added 
> it back to the array 'mdadm /dev/md8 -a /dev/sda10' output: 'mdadm: 
> added /dev/sda10'
> >From kernel log:
> [kernel] md: bind<sda10>

Are you sure there are no messages like:

raid5: cannot start dirty degraded array for md1

and 

raid5: failed to run raid set md1

??
In any case, try adding "--force" to "mdadm --assemble", but be aware
that data corruption may have happened.
If a raid5 suffers an unclean shutdown and a lost drive, it is
possible that some blocks will contain garbage, and impossible to know
which ones.

NeilBrown
