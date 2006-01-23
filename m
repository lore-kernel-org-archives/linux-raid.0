From: Shawn Usry <shawn@joebacardi.com>
Subject: Re: multiple Sata SATAII 150, TX4  - how to tell which drive is which?
	headaches galore!
Date: Mon, 23 Jan 2006 10:27:58 -0600
Message-ID: <20060123162758.0178b58b@ted.secure-tunnel.com>
References: <200601230336.55220.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200601230336.55220.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell:

----- Original Message -----
From: Mitchell Laks
[mailto:mlaks@verizon.net]
To: linux-raid@vger.kernel.org
Sent: Mon, 23 Jan
2006 02:36:54 -0600
Subject: multiple Sata SATAII 150, TX4  - how to tell
which drive is which? headaches galore!


> Dear Experts,
> 
> I wanted to ask for any experience with running raid with SATA drives and 
> controllers here under linux.
> 
> I have been having an interesting time!
> 
> I initially tried to use raid1 on  my asus A8v motherboard 
> using  a mixture of SATA controllers - 
> the built in motherboard SATA controller (via vt8237) 
> as well as a  Promise PCI card SATAII 150, 
> but had problems with the kernel. My drives gave me all sorts of errors
> while 
> trying to build the  raids and while running mkfs.ext3
> and i couldn't  get it to work reliably with the any of the current kernels
> I 
> tried, including 2.6.15.1 the current stable kernel. 
> I get countless kernel errors as I mentioned in an earlier post.
> 
> Now I have switched to only using the PCI card controllers ( Well, I can put
> 
> multiple controllers into the motherboard). So I use only sata_promise and 
> get rid of sata_via, which conflicts (according to my experience). 
> 
> Now however, when a drive gives me errors - how can I identify which drive
> on 
> which device is failing? 
> 
> The kernel seems to name things randomly.
> 
> This is important when a drive 'fails'. Which drive failed? If I am dealing 
> with /dev/hda1 /dev/hdb1 /dev/hdc1 /dev/hdd1  on the two ide channels
> then  I 'know' which is which.
> 
> Even crazier (from an accounting point of view) is  the following.
> 
> if I have 2 of these cards, then the sata_promise driver does not appear to 
> distinguish "where" (ie: which physical controller port on ___which___ card)
> 
> the drives are. 
> 
> The letters don't skip to show you are on a second controller -even if you 
> leave blank slots to try to see...
> The kernel  randomly  calls the drives sda sdb sdc sdd sde and they seem to
> be 
> anywhere on the physical controllers.  It seems to be completely random. 
> HELP!
> 
> I since I run a bunch of raid1's, if I get errors I have a major chore. So I
> 
> must stop and reboot countless times doing a binary search using mdadm 
> -E /dev/sd[ab]1 |grep UU to find the UUID's of the misbehaving drives.  
> Then 
> look closely at mdadm -E of the 2 final candidates to see which one gave me 
> these errors. 
> 
> For instance a new drive failed while I was installing the raid, and
> testing.
> To find the erroring drive I had to reproduce the errors each time by  
> creating the raids, and running mkfs.ext3 which seems to cause the errors. 
> What if the errors were more occult????
> 
> Each card had 4 controllers - however when I have more than 1 card it can be
> 
> even more difficult to identify where we are.
> 
> Any experience out there to help me?
> 
> Thanks,
> 
> Mitchell Laks
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
