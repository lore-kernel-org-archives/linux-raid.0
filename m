From: raz ben jehuda <razb@bitband.com>
Subject: Re: when does it become faulty disk
Date: Mon, 20 Jun 2005 18:35:32 +0300
Message-ID: <1119281732.3377.6.camel@raz-laptop>
References: <5d96567b05061804477325d743@mail.gmail.com>
	 <62b0912f05061912103ad3c459@mail.gmail.com>  <42B6C880.6020305@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42B6C880.6020305@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Molle Bestefich <molle.bestefich@gmail.com>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Mon, 2005-06-20 at 16:45, Michael Tokarev wrote:
> Molle Bestefich wrote:
> > Raz Ben-Jehuda(caro) wrote:
> > 
> >>I have managed to make the kernel remove a disk
> >>from my raid even if this raid is "/" . I did it by adding a line
> >>in ata_scsi_error that remove the ata disk from the raid array.
> >>This means that when the first error ocurrs on a disk It is removed
> >>from the array.
> >>Well, this is not the best thing to do..
> >>Question is :
> >>When does a disk become faulty ?
> > 
> > 
> > When trying to read sectors from a disk and the disk fails the read:
> >  1.)  Read the data from the other disks in the RAID and
> >  2.)  Overwrite the sectors where the read error occur.
> 
> Note: this is NOT how current linux softraid code works, it's
> how it *supposed* to work.  And right now, linux raid code
> kicks a drive out of the array after *any* error (read or
> write), without trying to "understand" what happened.
no accurate.
I have raid1 over "/" and whenever I pull out one of the disks
the system hangs. in order to fix it I added to ata_scsi_error()
ata_port_disable(). 
> /mjt
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Raz
Long Live The Penguin

