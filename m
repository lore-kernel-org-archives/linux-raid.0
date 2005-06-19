From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: when does it become faulty disk
Date: Sun, 19 Jun 2005 21:10:05 +0200
Message-ID: <62b0912f05061912103ad3c459@mail.gmail.com>
References: <5d96567b05061804477325d743@mail.gmail.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b05061804477325d743@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Raz Ben-Jehuda(caro) wrote:
> I have managed to make the kernel remove a disk
> from my raid even if this raid is "/" . I did it by adding a line
> in ata_scsi_error that remove the ata disk from the raid array.
> This means that when the first error ocurrs on a disk It is removed
> from the array.
> Well, this is not the best thing to do..
> Question is :
> When does a disk become faulty ?

When trying to read sectors from a disk and the disk fails the read:
 1.)  Read the data from the other disks in the RAID and
 2.)  Overwrite the sectors where the read error occur.
If this write also fails, then the disk has used up it's spare sectors
area.  The RAID array is now by definition in a degraded state since
that sector no longer exists in a redundant (readable at least) way. 
The disk should therefore be kicked, in order to notify the user that
it should be replaced immediately.

> Is when you have N errors in T time ?

Nah, it's when you run out of spare sectors and your data redundancy
is thereby lost that you have to fault the disk to prevent future data
loss.  Don't try to second-guess when the disk is going to get faulty
based on how many errors occurred.  If you want to do something like
that, read out the SMART data from the disk.  The manufacturer's data
about the disks health should be your data source.

> New ideas would be welcomed.

HTH..
