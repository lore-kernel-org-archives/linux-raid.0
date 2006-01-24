From: "Shawn Usry" <shawn@joebacardi.com>
Subject: RE: multiple Sata SATAII 150, TX4  - how to tell which drive is which?headaches galore!
Date: Mon, 23 Jan 2006 20:46:59 -0600
Message-ID: <002401c62090$741e9aa0$7601a8c0@homer>
References: <20060123174101.4ecf90b0@ted.secure-tunnel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060123174101.4ecf90b0@ted.secure-tunnel.com>
Content-Class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: 'Shawn Usry' <shawn@joebacardi.com>, 'Mitchell Laks' <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Confirmed.  Using the promise OEM driver, (ulsata2.ko) module the FC4 discovery order comes in exactly as printed on the board's themselves, ports 1-4.
 

-----Original Message-----
From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Shawn Usry
Sent: Monday, January 23, 2006 11:41 AM
To: Mitchell Laks; linux-raid@vger.kernel.org
Subject: Re: multiple Sata SATAII 150, TX4 - how to tell which drive is which?headaches galore!

Apologies for the previous uncompleted post.

Anyhoo - Mitchell, I've recently been experimenting with the the same board (TX4) in FC4.  Currently, I've got 2 boards installed.  

I've noticed, that when using the stock libata / sata_promise drivers that are in FC4, the discovery order on each board is:

3-2-4-1

Where each number represents the physical port label number imprinted on the TX4 board.

In other words:

/dev/sda = port 3
/dev/sdb = port 2

etc...

However, just last night I compiled and insmod'd the Promise-provided linux driver (I forget the module name), and noticed that the discovery order changes, to be exactly the same as the order that the TX4 bios discovers the drives.  I have not had a chance yet to figure out what this translates to in terms of the physical port labeling - I'll try to get that hammered out tonite and repost.

I also noticed, that with EITHER driver, the discovery order does stay within the bounds of one card, before moving on to the next TX4 board you might have installed.  In other words, you won't end up with /dev/sda being a drive in board A, and /dev/sdb being a drive in board B.  It will discover sequentially, at least with respect to the boards.

Hope this helps a bit.





----- Original Message -----
From: Mitchell Laks
[mailto:mlaks@verizon.net]
To: linux-raid@vger.kernel.org
Sent: Mon, 23 Jan
2006 02:36:54 -0600
Subject: multiple Sata SATAII 150, TX4  - how to tell which drive is which? headaches galore!


> Dear Experts,
> 
> I wanted to ask for any experience with running raid with SATA drives 
> and controllers here under linux.
> 
> I have been having an interesting time!
> 
> I initially tried to use raid1 on  my asus A8v motherboard using  a 
> mixture of SATA controllers - the built in motherboard SATA controller 
> (via vt8237) as well as a  Promise PCI card SATAII 150, but had 
> problems with the kernel. My drives gave me all sorts of errors while 
> trying to build the  raids and while running mkfs.ext3 and i couldn't  
> get it to work reliably with the any of the current kernels I tried, 
> including 2.6.15.1 the current stable kernel.
> I get countless kernel errors as I mentioned in an earlier post.
> 
> Now I have switched to only using the PCI card controllers ( Well, I 
> can put
> 
> multiple controllers into the motherboard). So I use only sata_promise 
> and get rid of sata_via, which conflicts (according to my experience).
> 
> Now however, when a drive gives me errors - how can I identify which 
> drive on which device is failing?
> 
> The kernel seems to name things randomly.
> 
> This is important when a drive 'fails'. Which drive failed? If I am 
> dealing with /dev/hda1 /dev/hdb1 /dev/hdc1 /dev/hdd1  on the two ide 
> channels then  I 'know' which is which.
> 
> Even crazier (from an accounting point of view) is  the following.
> 
> if I have 2 of these cards, then the sata_promise driver does not 
> appear to distinguish "where" (ie: which physical controller port on 
> ___which___ card)
> 
> the drives are. 
> 
> The letters don't skip to show you are on a second controller -even if 
> you leave blank slots to try to see...
> The kernel  randomly  calls the drives sda sdb sdc sdd sde and they 
> seem to be anywhere on the physical controllers.  It seems to be 
> completely random.
> HELP!
> 
> I since I run a bunch of raid1's, if I get errors I have a major 
> chore. So I
> 
> must stop and reboot countless times doing a binary search using mdadm 
> -E /dev/sd[ab]1 |grep UU to find the UUID's of the misbehaving drives.
> Then
> look closely at mdadm -E of the 2 final candidates to see which one 
> gave me these errors.
> 
> For instance a new drive failed while I was installing the raid, and 
> testing.
> To find the erroring drive I had to reproduce the errors each time by 
> creating the raids, and running mkfs.ext3 which seems to cause the errors.
> What if the errors were more occult????
> 
> Each card had 4 controllers - however when I have more than 1 card it 
> can be
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
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
> 
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html




