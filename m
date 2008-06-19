From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Segfault with --assemble --force
Date: Thu, 19 Jun 2008 13:52:22 +1000
Message-ID: <18521.55286.158619.223076@notabene.brown>
References: <20080618193554.GA30682@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Webb on Wednesday June 18
Sender: linux-raid-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 18, chris@arachsys.com wrote:
> mdadm --assemble --force repeatedly segfaults when run on a raid6 array with
> more than two components marked as failed, so at least one needs its event
> count forcibly updated. sb->events is accessed with sb NULL in update_super1,
> called from Assemble (line 667 of Assemble.c). I think the following patch is
> correct:
> 
> diff -uNrp mdadm-2.6.7.orig/Assemble.c mdadm-2.6.7/Assemble.c
> --- mdadm-2.6.7.orig/Assemble.c	2008-06-18 20:23:36.000000000 +0100
> +++ mdadm-2.6.7/Assemble.c	2008-06-18 20:23:47.000000000 +0100
> @@ -656,7 +656,7 @@ int Assemble(struct supertype *st, char 
>  			continue;
>  		}
>  		tst = dup_super(st);
> -		if (tst->ss->load_super(st,fd, NULL)) {
> +		if (tst->ss->load_super(tst, fd, NULL)) {
>  			close(fd);
>  			fprintf(stderr, Name ": RAID superblock disappeared from %s - not updating.\n",
>  				devices[chosen_drive].devname);
> 

Yes, definitely.

Thanks.

NeilBrown
