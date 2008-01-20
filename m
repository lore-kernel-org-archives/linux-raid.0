From: Mitchell Laks <mlaks@post.harvard.edu>
Subject: Re: how to create a degraded raid1 with only 1 of 2 drives ??
Date: Sun, 20 Jan 2008 14:52:53 -0500
Message-ID: <20080120195253.GA11393@earthlink.net>
References: <20080120192801.GA11149@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080120192801.GA11149@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think my error was that maybe I did not
do write the fdisk changes to the drive with 
fdisk w

so I did
fdisk /dev/sda
p
then 
w
and then when I did

mdadm -C /dev/md0 --level=2 -n2 /dev/sda1 missing

it worked and set up the array.

Thanks for being there!

Mitchell
