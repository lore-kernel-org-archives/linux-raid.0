From: John McNulty <johnmcn1@googlemail.com>
Subject: Re: What will happen with spares in this scenario?
Date: Tue, 30 Jun 2009 21:47:33 +0100
Message-ID: <59D0D540-60D3-45EE-B917-56D2A262991C@googlemail.com>
References: <ab50889f0906290828s44e10b14n1af6d23556e3f0ee@mail.gmail.com> <87zlbruinb.fsf@frosties.localdomain> <BD450977-FA0D-4F63-8ADB-1314FA43E654@googlemail.com> <87r5x2xs7i.fsf@frosties.localdomain> <ab50889f0906300116p42b48afnf1605ea1e8cdf60c@mail.gmail.com> <87d48l8v4d.fsf@frosties.localdomain>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d48l8v4d.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 30 Jun 2009, at 18:54, Goswin von Brederlow wrote:

> In case of grub2: It does support both raid and lvm. The raid
> superblocks are parsed to construct mdX devices and the lvm metadata
> is parsed to locate lvm logical volumes. So you could say it does
> construct the LV and mounts the FS.

Interesting, thanks.  I've not been following grub2 development.   
Given the production nature of these systems though (and the customer)  
I'm stuck with grub legacy until Redhat update it and support grub2,  
which judging from the chatter on the Fedora Project Portal about the  
possibility of including it in Fedora 12, could be some years off.   
Looks like Ubuntu will be putting it into 9.10 though, so I'll have a  
play with it on one of my dev boxes at home.

> In case of lilo: Lilo only stores a list of blocks where the
> kernel/initrd are on the device. Afaik each component device of a raid
> stores the the block numbers for the kernel/initrd on that component
> device. So no matter which component device boots it will find the
> kernel/initrd on the same device. The raid1 and lvm are completly
> circumvented.

Have not touched lilo since grub went main stream, but will have  
another look at that.

I've gone over all this with the customer.  They want belt and braces  
protection (they are to be very critical systems in a hospital) so  
we've decided to hardware mirror c0d0 and c0d1 for the disks on one  
controller, plus the same for c1d0 and c1d1 on the second controller,  
then partition and md mirror both of those.  The rest of the disks  
will be handled separately and the kickstart config is quite simple.   
It's a bit overkill, but it won't be failing disks or controllers that  
cause the systems to fail in the future.

Rgds,

John


