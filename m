From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Thu, 21 Nov 2002 10:48:47 +1100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <15836.8031.649441.843857@notabene.cse.unsw.edu.au>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
	<3DDBC0D9.5030904@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: message from Steven Dake on Wednesday November 20
To: Steven Dake <sdake@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 20, sdake@mvista.com wrote:
> Neil,
> 
> I would suggest adding a 64 bit field called "unique_identifier" to the 
> per-device structure.  This would allow a RAID volume to be locked to a 
> specific host, allowing the ability for true multihost operation.

You seem to want a uniq id in 'per device' which will identify the
'volume'.
That doesn't make sense to me so maybe I am missing something.
If you want to identify the 'volume', you put some sort of id in the
'per-volume' data structure.

This is what the 'name' field is for.

> 
> For FibreChannel, we have a patch which places the host's FC WWN into 
> the superblock structure, and only allows importing an array disk (via 
> ioctl or autostart) if the superblock's WWN matches the target dev_t's 
> host fibrechannel WWN.  We also use this for environments where slots 
> are used to house either CPU or disks and lock a RAID array to a 
> specific cpu slot.  WWNs are 64 bit, which is why I suggest such a large 
> bitsize for this field.  This really helps in hotswap environments where 
> a CPU blade is replaced and should use the same disk, but the disk 
> naming may have changed between reboots.
> 
> This could be done without this field, but then the RAID arrays could be 
> started unintentionally by the wrong host.  Imagine a host starting the 
> wrong RAID array while it has been already started by some other party 
> (forcing a rebuild) ugh!

Put your 64 bit WWN in the 'name' field, and teach user-space to match
'name' to FC adapter.

Does that work for you?

NeilBrown
