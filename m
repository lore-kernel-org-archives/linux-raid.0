From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: And then there was Bryce...
Date: Thu, 8 Jun 2006 08:54:51 -0700 (PDT)
Message-ID: <e69h8b$5u1$1@terminus.zytor.com>
References: <44877242.2060803@zeniv.linux.org.uk> <4487C5F6.2080107@idgmail.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <4487C5F6.2080107@idgmail.se>
By author:    Henrik Holst <henrik.holst@idgmail.se>
In newsgroup: linux.dev.raid
> 
> The same happened to me with eth0-2. I _could_ not for my life
> understand why I didn't get internet connect to work. But then I
> realized that eth0 and eth1 had been swapped after I upgraded to udev.
> Please advice your distribution udev documentation how to "lock down"
> scsi and network cards to specific kernel names.
> 

This doesn't explain how come it bound drives without superblocks.
It should only bind drives with the correct superblock UUID, EVER.

Udev doesn't actually matter here, since the kernel, not udev, assigns
the numbers to the drives.

	-hpa
