From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 reliability (was raid5 write performance)
Date: Sat, 19 Nov 2005 19:27:10 -0500
Message-ID: <200511200027.jAK0RQw19221@www.watkins-home.com>
References: <17279.32081.740196.178730@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17279.32081.740196.178730@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: 'Carlos Carvalho' <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Carlos Carvalho
> Sent: Saturday, November 19, 2005 2:30 PM
> To: linux-raid@vger.kernel.org
> Subject: raid5 reliability (was raid5 write performance)
> 
> Guy (bugzilla@watkins-home.com) wrote on 19 November 2005 00:56:
>  >Assume a single stripe has data for 2 different files (A and B).  A disk
> has
>  >failed.  The file system writes a 4K chunk of data to file A.  The
> parity
>  >gets updated, but not the data.  Or the data gets updated but not the
>  >parity.  The system crashes or power fails.  The system recovers, but
> can't
>  >do anything about the parity with a failed disk.
> 
> But this is just the case Neil mentioned: an unclean degraded array.
> This is the only case where data corruption can appear.

Ok, so Neil hit send 1 minute before me, sorry.  :)

> 
>  >Also, after a power failure, I have seen the system come back with a
> single
>  >disk failed.  I guess that 1 disk had an expired superblock.
> 
> You mean the disk was fine and operating in the array before the power
> failure? If so the superblocks were all in sync. If one of the
> superblocks was different the array was already degraded and after the
> power failure it'll also be dirty, and we're back at the case above.

Yes, everything was fine, but while the superblocks were being updated,
BANG!  Now 1 is out of date.  I think on reboot that 1 disk will be failed.
But I am not sure of this.  I do know I had 1 disk dropped from my array
after a loss of power.  I did not have any emails telling me a disk had
failed.  So, I think the power failure led to the disk being dropped from
the array.  I did not pursue how or why, I just added the disk back.  I
don't really know if this can lead to data corruption.  I guess the stripes
would be updated before the superblock updates start.  But not sure.  But if
so, then I don't see how this case can corrupt data.

> 
>  >When you add that disk back, any stripes that were not up to date
>  >will be re-constructed with invalid data.
> 
> If the array was not degraded the reconstruction data will not be
> invalid. Only the parity will be rebuilt and no data corruption will
> happen.

No, if you add a disk, it is re-built 100%.  At least with my version.  The
intent log may resolve this, but I am not sure.

> 
>  >I don't know if the intent logging will help here or not.
> 
> It won't change anything, it only helps to accelerate the resync by
> not re-writing stripes that were up to date.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

To the best of my knowledge, I have never had corrupt data.

Guy

