From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md.c patch for root on RAID-10
Date: Fri, 30 Apr 2004 13:41:16 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16529.51932.127405.475414@cse.unsw.edu.au>
References: <20040421081936.GS1352@glasswings.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Pam on Wednesday April 21
To: Andrew Pam <xanni@glasswings.com.au>
Cc: Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 21, xanni@glasswings.com.au wrote:
> I have a server that is configured with the root partition on a RAID-10
> array (/dev/md5 is RAID-1 /dev/md[34], /dev/md3 is RAID-0 /dev/sd[ab]2,
> /dev/md4 is RAID-0 /dev/sd[cd]2).
> 
> This server boots Linux kernel 2.6.3 off /dev/md0 RAID-1 /dev/sd[abcd]1
> (about to upgrade to 2.6.5) but unfortunately requires a complicated
> custom initrd to boot correctly since the RAID autorun code does not
> appear to autostart multilayer RAID arrays.  Can you offer me any
> assistance in patching md.c to make it check if any autostarted RAID
> arrays are themselves components of other RAID arrays that should also
> be autostarted?

The simplest approach is to add a kernel parameter which will assemble
md5:

   md=5,/dev/md3,/dev/md4 root=/dev/md5

If that doesn't work, let me know and I will fix it.

ByTheWay, you have your raid10 upside-down.
It is more reliable to build raid1 arrays out of real drives, and then
a raid0 out of the raid1s.

NeilBrown
