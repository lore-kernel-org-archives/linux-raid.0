From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [klibc] Re: Exporting which partitions to md-configure
Date: Mon, 06 Feb 2006 18:47:54 -0800
Message-ID: <43E80A5A.5040002@zytor.com>
References: <43DEB4B8.5040607@zytor.com>	<17374.47368.715991.422607@cse.unsw.edu.au>	<43DEC095.2090507@zytor.com>	<17374.50399.1898.458649@cse.unsw.edu.au>	<43DEC5DC.1030709@zytor.com> <17382.43646.567406.987585@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17382.43646.567406.987585@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> What constitutes 'a piece of data'?  A bit? a byte?
> 
> I would say that 
>    msdos:fd
> is one piece of data.  The 'fd' is useless without the 'msdos'.
> The 'msdos' is, I guess, not completely useless with the fd.
> 
> I would lean towards the composite, but I wouldn't fight a separation.
> 

Well, the two pieces come from different sources.

> 
> Just as there is a direct unambiguous causal path from something
> present at early boot to the root filesystem that is mounted (and the
> root filesystem specifies all other filesystems through fstab)
> similarly there should be an unambiguous causal path from something
> present at early boot to the array which holds the root filesystem -
> and the root filesystem should describe all other arrays via
> mdadm.conf
> 
> Does that make sense?
> 

It makes sense, but I disagree.  I believe you are correct in that the 
current "preferred minor" bit causes an invalid assumption that, e.g. 
/dev/md3 is always a certain thing, but since each array has a UUID, and 
one should be able to mount by either filesystem UUID or array UUID, 
there should be no need for such a conflict if one allows for dynamic md 
numbers.

Requiring that mdadm.conf describes the actual state of all volumes 
would be an enormous step in the wrong direction.  Right now, the Linux 
md system can handle some very oddball hardware changes (such as on 
hera.kernel.org, when the disks not just completely changed names due to 
a controller change, but changed from hd* to sd*!)

Dynamicity is a good thing, although it needs to be harnessed.

 > kernel parameter md_root_uuid=xxyy:zzyy:aabb:ccdd...
 >    This could be interpreted by an initramfs script to run mdadm
 >    to find and assemble the array with that uuid.  The uuid of
 >    each array is reasonably unique.

This, in fact is *EXACTLY* what we're talking about; it does require 
autoassemble.  Why do we care about the partition types at all?  The 
reason is that since the md superblock is at the end, it doesn't get 
automatically wiped if the partition is used as a raw filesystem, and so 
it's important that there is a qualifier for it.

	-hpa
