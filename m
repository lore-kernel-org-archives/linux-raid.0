From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Problems with SCSI devices renaming...
Date: Tue, 19 Oct 2004 10:08:10 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041019150810.GA1074@lists.us.dell.com>
References: <001201c4b5ea$958f0790$30493c86@clever>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001201c4b5ea$958f0790$30493c86@clever>
To: Martin Clauss <clauss@neuro.informatik.uni-ulm.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 19, 2004 at 04:47:40PM +0200, Martin Clauss wrote:
>                 device /dev/scsi/host2/bus0/target11/lun0/part1
>                 device /dev/scsi/host2/bus0/target12/lun0/part1
> 
> This works very fine so far. But when I attach an additional device to this
> DEC Storage Device, I get an additional target on this SCSI bus. Now this
> doesn't matter for the devfs names, but the superblock of the RAID saves
> major/minor numbers that are wrong now. So the raid won't start anymore....
> Shouldn't autodetect handle exactly this problem? (Yes, partition type is
> linux raid autodetect for all raid disks...)
> 
> I guess, this should be a quite common problem, so I hope to find some
> answers here.

You want something like udev (2.6 kernels) or devlabel (2.4 kernels,
http://linux.dell.com/projects.shtml), and to use those names rather
than devfs names.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
