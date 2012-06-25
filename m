From: Manfred_Knick <Manfred.Knick@T-Online.de>
Subject: kernel 3.4.3 + e2fsprogs 1.42 + hdparm-9.39 : Raid-1 : complete data
 loss
Date: Mon, 25 Jun 2012 22:21:10 +0200
Message-ID: <4FE8C836.5040004@T-Online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--------------
Short version:
--------------

Needing more space on my (quicker) HW-Raid-10,
I wanted to transfer ~850 GiB to a (slower) SW-Raid1.

Creation succeded, Transfer succeeded,
Compare (diff) succeded,
even Reboot succeded;
but after Power Off / Boot: all data lost,
filesystem only offering an empty "lost+found".

I'm _not_ really sure that this strange effect
is to be considered a kernel problem
or a RAID problem (yet),
but thought it might make sense to give a warning.

----- cite ----- [PM]

... there is no evidence of a problem with RAID.  The filesystem has
lost its contents.  So it *looks* like an error with "rm" or "mkfs".  It
possibly isn't that simple but it doesn't look at all like a RAID problem.

NeilBrown

----- /cite -----
[@Neil: Thank you for looking at it and for your comment]


I am continung to work on additional experiments,
but unfortunately they take soo loong ...

I am prepared to provide additional information as requested;
proposals how to debug this strange coincidence are welcome.


-------------
Long version:   Please c.f.
-------------

https://bugzilla.kernel.org/show_bug.cgi?id=43791

Yours respecfully

Manfred Knick
