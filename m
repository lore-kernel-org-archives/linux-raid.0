From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm --detail showing annoying device
Date: Thu, 22 Oct 2009 08:46:17 +1100
Message-ID: <19167.33065.766493.889406@notabene.brown>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>
	<20091019030456.GS9464@discord.disaster>
	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>
	<20091020003358.GW9464@discord.disaster>
	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>
	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
	<4ADF17EC.6090606@forumdesimages.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephane Bunel on Wednesday October 21
Sender: linux-raid-owner@vger.kernel.org
To: Stephane Bunel <stephane.bunel@forumdesimages.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 21, stephane.bunel@forumdesimages.fr wrote:
> Hi,
> 
> I'm a newbie in the mdadm world. I defined some udev rules to make disk 
> staticly named according to the bus/host/target. I.e. /dev/sda become 
> /dev/raid_disk0. So nothing very special with that, it's just a convenient way 
> to assign disk name to it's physical location.
> 
> #ls -la /dev/raid*
> brw-rw---- 1 root disk 8,  0 2009-10-16 18:12 /dev/raid_disk0
> brw-rw---- 1 root disk 8, 16 2009-10-16 18:12 /dev/raid_disk1
> 
> A RAID1 (/dev/md0) is assembled over this two disk.
> When looking for detailed information, mdadm show annoying device name in 
> place of /dev/raid_disk*:
> 
....
>      Number   Major   Minor   RaidDevice State
>         0       8        0        0      active sync   /dev/char/21:0
>         1       8       16        1      active sync   /dev/char/21:1

What is a block device doing in /dev/char ???  There should only be
character devices in there.

If these are actually block device, then I think there is something
wrong with your udev rules.
If these are char devices, then mdadm is doing the wrong thing, but I
cannot see that from the code.

Your proposal of choosing the highest rather than the shortest name
has some merit, but I your current situation doesn't seem to justify
it, and I particularly like the simplicity of the current heuristic.

So for now I think I'll leave it as it is and encourage you to fix
your udev rule.

Thanks,
NeilBrown
