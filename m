From: Matthias Julius <jnews@julius-net.net>
Subject: Re: Raid5 with 2 bad drives
Date: Tue, 22 Feb 2005 19:40:02 -0500
Message-ID: <87fyzoaz31.fsf@julius-net.net>
References: <u650k4kbd.fsf@julius-net.net> <Pine.LNX.4.56.0502221656160.4157@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson <gordon@drogon.net> writes:

> Try something like:
>
>   mdadm --assemble /dev/mdY /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 \
> 	--run --force

--force did the trick.  I could have thought of that one myself.
Thanks.

As for not hitting the bad blocks again: Is there a way to find out to
which file they belong with ext3/xfs on LVM on RAID5?  That would be
helpfull.

Matthias

