From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid1 faulty disk --> hot adding
Date: Fri, 10 Jun 2005 11:00:11 +1000
Message-ID: <17064.58907.391363.673963@cse.unsw.edu.au>
References: <5d96567b050609161261740204@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Friday June 10
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 10, raziebe@gmail.com wrote:
> Hello guys.
> I tried to to raidhotadd a faulty disk to a mirror and it failed
> saying that "bd_claim failed on..."
> i took a dive into the  code and it seems that when a disk in the raid
> fails the bd_holder fileld in
> the block_device struct remained with the old value although the disk
> was faulty.
> So the logical thing to do was to set rdev->bdev->bd_holder to 0x00 .
> I did it in the error() routine in raid1.c .
> This way I manage to hotadd a disk.
> Are there anyone here that can point his view regarding this matter  ?

If a drive fails, and you want to re-add it, what you should do is
first remove it, and then add it.
  raidhotremove /dev/mdX /dev/sdY
  raidhotadd /dev/mdX /dev/sdY

(or equivalent mdadm commands).

clearing bd_holder is certainly not the right thing to do.

NeilBrown

