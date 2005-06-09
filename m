From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: raid1 faulty disk --> hot adding
Date: Fri, 10 Jun 2005 02:12:21 +0300
Message-ID: <5d96567b050609161261740204@mail.gmail.com>
Reply-To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello guys.
I tried to to raidhotadd a faulty disk to a mirror and it failed
saying that "bd_claim failed on..."
i took a dive into the  code and it seems that when a disk in the raid
fails the bd_holder fileld in
the block_device struct remained with the old value although the disk
was faulty.
So the logical thing to do was to set rdev->bdev->bd_holder to 0x00 .
I did it in the error() routine in raid1.c .
This way I manage to hotadd a disk.
Are there anyone here that can point his view regarding this matter  ?
--
Raz
Long Live the Penguin
