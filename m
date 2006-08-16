From: dean gaudet <dean@arctic.org>
Subject: Re: Is mdadm --create safe for existing arrays ?
Date: Wed, 16 Aug 2006 09:21:24 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0608160918570.28447@twinlark.arctic.org>
References: <20060816152645.9761.qmail@web34611.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060816152645.9761.qmail@web34611.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Greis <peter_greis@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Aug 2006, Peter Greis wrote:

> So, how do I change / and /boot to make the super
> blocks persistent ? Is it safe to run "mdadm --create
> /dev/md0 --raid-devices=2 --level=1 /dev/sda1
> /dev/sdb1" without loosing any data ?

boot a rescue disk

shrink the filesystems by a few MB to accomodate the superblock

mdadm --create /dev/md0 --raid-devices=2 --level=1 /dev/sda1 missing
mdadm /dev/md0 -a /dev/sdb1

grow the filesystem

you could probably get away with an --assume-clean and no resync if you 
know the array is clean... just don't forget to shrink/grow the 
filesystem.

-dean
