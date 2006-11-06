From: Nix <nix@esperi.org.uk>
Subject: Re: invalid (zero) superblock magic upon creation of a new RAID-1 array
Date: Mon, 06 Nov 2006 20:20:17 +0000
Message-ID: <873b8ws4xq.fsf@hades.wkstn.nix>
References: <20061105085702.GD20184@grok.co.za>
	<17742.25334.685135.990170@cse.unsw.edu.au>
	<20061106064233.GA2793@grok.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061106064233.GA2793@grok.co.za> (Thomas Andrews's message of "6 Nov 2006 06:43:29 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Andrews <tandrews@grok.co.za>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 6 Nov 2006, Thomas Andrews uttered the following:
> Thanks Neil, I fixed my problem by creating the raid set using the "-e"
> option:
>
>     mdadm -C /dev/md0 -e 0.90 --level=raid1 --raid-devices=2  /dev/sda1 /dev/sdb1
>
> You're suggestion to use mdadm to assemble the array is not an option
> for me because it is the root partition that is raided, but thanks for
> putting me in the right direction.

You can still use mdadm to assemble root filesystems: you just need
an initramfs or initrd to do the work before / is mounted. (As a
bonus you can fsck it before it's mounted, as well.)

Most distros have tools that can do this for you, or you can do it by
hand (see e.g. <http://linux-raid.osdl.org/index.php/RAID_Boot>).

-- 
`When we are born we have plenty of Hydrogen but as we age our
 Hydrogen pool becomes depleted.'
