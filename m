From: michael@estone.ca
Subject: Re: how to create a degraded raid1 with only 1 of 2 drives ??
Date: Sun, 20 Jan 2008 11:34:40 -0800
Message-ID: <20080120113440.vhryijr7tcck4wws@estone.ca>
References: <20080120192801.GA11149@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080120192801.GA11149@earthlink.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Mitchell Laks <mlaks@post.harvard.edu>:

> Hi mdadm raid gurus,
>
> I wanted to make a raid1 array, but at the moment I have only 1   
> drive available. The other disk is
> in the mail. I wanted to make a raid1 that i will use as a backup.
>
> But I need to do the backup now, before the second drive comes.
>
> So I did this.
>
> formated /dev/sda creating /dev/sda1 with type fd.
>
> then I tried to run
> mdadm -C /dev/md0 --level=1 --raid-devices=1 /dev/sda1

Perhaps give this a try:

# mdadm -C /dev/md0 --level=1 --raid-devices=2 /dev/sda1 missing

Cheers,
Mike
