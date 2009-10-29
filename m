From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: small mdadm issue under debian
Date: Thu, 29 Oct 2009 12:04:51 -0600
Message-ID: <200910291204.51703.tfjellstrom@shaw.ca>
References: <200910290124.59090.tfjellstrom@shaw.ca> <200910291120.24803.tfjellstrom@shaw.ca> <4AE9D337.30609@shiftmail.org>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE9D337.30609@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu October 29 2009, Asdo wrote:
> Thomas Fjellstrom wrote:
> >> Then reboot to a new kernel and see if it auto assembles.
> >
> > I don't have them auto assemble in initrd/initramfs. Its done later in
> > the mdadm-raid script if I read it correctly. Its also a 1.1 metadata
> > array, so the kernel can't auto assemble it itself.
> 
> You probably mean "it can't auto assemble it itself without an
> initramfs"! :-D

Maybe I'm being a little pedantic, but initramfs is a miniature userspace so 
it isn't the kernel that is doing the auto assembling ;) just an embedded 
mdadm ;)
 
> I have my root filesystem on a 1.0 metadata raid on 2.6.31 so it
> definitely assembles it...
> For 1.1 I suppose it's the same.
> But it does need to be in the /etc/mdadm/mdadm.conf that is packed in
> the initramfs, so make sure the problem is not that one, try by
> unpacking the initramfs with cpio
> 

I don't need it to assemble my array at boot time, the array is used for 
media files, not the root partition. I would however like the mdadm-raid 
script to be able to assemble the array during boot, which works under 
2.6.26, and not under 2.6.29,.30, or .31.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
