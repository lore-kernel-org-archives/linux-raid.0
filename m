From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: Raid Persistent Superblock Question..
Date: Sun, 19 Jan 2003 18:07:46 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1030119180436.30448A-100000@Maggie.Linux-Consulting.com>
References: <008e01c2c027$3c9042e0$c7e60c0a@mihaisandu2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008e01c2c027$3c9042e0$c7e60c0a@mihaisandu2>
To: Sandu Mihai <mihai.sandu@kpnqwest.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya

i've moved raid drives from one box to another box with no problems...
i think oyu are running into "LABEL=xxx" problems in /etc/fstab
	( get rid of that sillyness ... makes sw-raid go bonkers )

and make sure your disk partitions are "FD" type

and if you wanna move the drives from /dev/md0  to  /dev/md7
just modify  /etc/raidtab accordingly .. (rename to /dev/md7 ) 
	- i havent had to play w/ superblocks

c ya
alvin


On Mon, 20 Jan 2003, Sandu Mihai wrote:

> Ok. I am carefull. But, I want to be able to mangle with the superblock, in
> order to have my kernel 'autodetect' a disk as being a member of a specific
> md device.
> 

