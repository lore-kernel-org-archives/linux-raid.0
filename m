From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Spares and partitioning huge disks
Date: Sun, 09 Jan 2005 19:36:03 +0300
Message-ID: <41E15D73.9020203@tls.msk.ru>
References: <200501091623.j09GNG917488@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501091623.j09GNG917488@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> Bad sectors are detected on write.  There are 5 wires going to each of the

Bad sectors can be detected both on write and on read.  Unfortunately,
most time there will be *read* error -- it is pretty possible for the
drive to perform a read-check after write, and the data may be ok at
that time, but not when you will want to read it a month later...

> read/write heads on my disk drives.  I think each head can read after write
> in 1 pass.  My specs say it re-maps on write failure and read failure.  Both
> are optional.  But, I don't know if this is normal or not.  My disks are
> Seagate ST118202LC, 10,000 RPM, 18 Gig SCSI.

I think all modern drives support bad block remapping on both read and write.
But think about it: if there's a read error, it means the drive CAN NOT read
the "right" data for some reason (for some definition of "right" anyway) --
ie, the drive "knows" there's some problem with the data and it can't
completely reconstruct what has been written to the block before.  In this
case, while remapping the block in question help to avoid further error in
this block, it does NOT help to restore the data which the drive can't read.

And sure it is not an option in this case to report that read was successeful
and to pass, say, zero-filled block to the controller... ;)

/mjt
