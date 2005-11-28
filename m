From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sun, 27 Nov 2005 22:19:44 -0500
Message-ID: <061e01c5f3ca$942bd0d0$200a11ac@NCNF5131FTH>
References: <17290.11404.619425.81197@cse.unsw.edu.au> <05d301c5f3c0$fb6f6860$200a11ac@NCNF5131FTH> <20051128022412.GA26118@jose.lug.udel.edu> <060001c5f3c4$23e35dd0$200a11ac@NCNF5131FTH> <20051128031149.GB26118@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@jose.lug.udel.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 27 November 2005 22:08:04, Ross Vandegrift wrote:
> Well, more generally, it's used when something needs to happen before
> the kernel can mount your root partiton.  Sometimes this means DHCPing
> for an IP and mounting an NFS drive, it often means loading kernel
> modules.  In your case, it means using mdadm to start the RAID
> devices.
>
> http://www.faqs.org/docs/evms/x3834.html that link is pretty helpful
> information on how to build an initrd manually.  It's aimed at people
> using EVMS, but the general lessons it teaches about building the
> image are generally sound.

Thanks! I've used EVMS in the past... I was trying to grow my raid5. It 
looks like it would have done the job, except it was going to take a week... 
I opted to go the backup, recreate, and restore route.

-- David M. Strang



