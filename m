From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 09:23:13 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310280923.13237.dusty@strike.wu-wien.ac.at>
References: <3F9DAD4C.3000002@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F9DAD4C.3000002@verizon.net>
Content-Disposition: inline
To: berk walker <berk.walker@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 28 October 2003 00:42, berk walker wrote:
> The purpose of my going to raid is to ensure, short of a total
> meltdown/fire, etc, data loss prevention.  If my house and business
> burn, I'm hosed anyway.

Maybe you'r hosed but note that it's not _that_ complicated to prevent 
dataloss in case of catastrophic events (fire/theft).

A simple single external (USB/Firewire, now SATA) drive that you store in 
another location can be a huge advantage. You could e.g. buy 2 external 
drives, leave one plugged into your server (copy data every night onto this 
disk), store the other in a different location and swap these drives every 
week.

> I am buying 4 maxtor 40 gb/200mb ultra 133 drives, and another promise
> board, to finally do swraid5 (after reading this list for a few months,
> it seems pretty scary in failure).

I would suggest to buy quality drives. Two disk failures are not very common 
but can occur. Sometimes a single quality drive can be more reliable than 4 
low quality drives bundled to a 4disk-RAID5.

I personally like the Western Digital "JB" (Special Edition) series and the 
new, although quite expensive, Raptor series. Moreover they provide excellent 
performance.

A measure for the quality of a drive may be the warranty, WD gives 3 years on 
the "JB"-series and 5 years on the Raptors.

> is there an advantage to >more< than 1 spare drive? .. more than 3
> drives in mdx?  why not cp old boot/root/whatever drive to mdx after
> booting on floppy?

Maybe I don't fully understand your question but a spare drive means normally 
"hot spare" - e.g. if a disk fails, the spare disk gets used. So if you have 
a 3-disk RAID5 plus 2 spares, you can loose 3 disks (not at the same time!) 
and still do not suffer from data loss.

> is there an advantage to having various mdx's allocated to various
> /directories?..ie: /home, var, /etc

It certainly makes sense to make different partitions to prevent dataloss due 
to file system corrpution and the like. I partition my personal system like 
that:

First on "/"
Second on "/var"
Third on "/home"

In some cases you could also add another small partition for "/boot".

Anyway, the more partitions you create, the more space gets lost: Let's say 
you want to store a 4GB file, and there is 2GB on "/", 1GB on "/var" and 
1.5GB on "home" left...

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

