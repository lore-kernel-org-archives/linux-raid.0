From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 05:23:19 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050105051955.9045B-100000@Maggie.Linux-Consulting.com>
References: <41DBD741.4070000@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DBD741.4070000@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 5 Jan 2005, Brad Campbell wrote:

> Picture lpd gets swapped out on a friday night. Over the weekend it is not used and the drive 
> develops a bad sector in the middle of the file. Monday morning I want to print and the system tries 
> to page lpd back in again. *boom*.

admin issue ... user related services like printers should NOT be on
critical servers and take down what everybody will notice due to unrelated
printer problems

swap ...  swap partitions is by default checked for bad blocks during
formatting as swap ...
	- it is highly unlikely that you'd get a bad sector in swap space

- any normal bad things happening to user area of the disks will also
  happen to swap space
 	- but its unlikely that swap will have bad blocks, while its 
	more likely that users did nto do a badblock check during
	formatting across the 100GB or 300GB disks ... and even more
	time twiddling your thumbs on raid'd disks

c ya
alvin

> I have not looked at the system swap algorithms, but I doubt they include automatic bad block 
> management and read after write verification. I'm making big assumptions here, but I'm assuming they 
> rely on a bad block table created by mkswap and an otherwise clean, functioning swap area.
> 
> Regards,
> Brad
> 

