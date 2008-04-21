From: jay@bernard.vm.bytemark.co.uk
Subject: Re: Incorrect array member slot assignment during assemble
Date: Mon, 21 Apr 2008 16:20:14 +0000
Message-ID: <20080421162014.at1xgstvtq8c048c@mail.jp-hosting.net>
References: <20080420183552.c0g0cm4mucsc8844@mail.jp-hosting.net>
	<18443.63473.834200.366911@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18443.63473.834200.366911@fisica.ufpr.br>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Carlos Carvalho <carlos@fisica.ufpr.br>:

> jay@bernard.vm.bytemark.co.uk (jay@bernard.vm.bytemark.co.uk) wrote   
> on 20 April 2008 18:35:
>  >I had a single disk failure in a 3-disk RAID5 array recently, and have
>  >been trying to reassemble the array with the remaining devices, but am
>  >running into some issues.
>  >
>  >The failed disk died during synchronization into the array,
>
> Did another one fail during the resync? If not you can try to
> reassemble the array with only the 2 good disks using --force.

The array did fall offline shortly after the first failure, which  
seemed unexpected; the two remaining disks (and controller) still seem  
healthy (states 'clean' and 'active' respectively), just that they  
refuse to assemble.

> If a second disk failed you're in trouble. Since the array stopped at
> the moment of the second failure, the two disks are still in sync.
> Well, almost... You can then make an image of the second failed disk
> on a good one and use --force to reassemble again. Then fsck...

This sounds good - the only filesystem mounted over the devices was  
read-only at the time, so I'm hoping that the two good disks should  
still be enough for some data recovery.

The only problem I see is that if I make a raw image copy of the  
second disk, it will still have the incorrect 'slot' assignment in the  
superblock.  I suppose I could dd everything except the superblock -  
but is there a mechanism to repair/recreate the superblock on a raw  
disk?

The other idea I have in mind is to - after a backup - recreate the  
array using the initial configuration (raid-level 5, num-devices 3,  
etc), and hope that the array can pick itself up again.

Any thoughts much appreciated - thanks for helping out :)

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

