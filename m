From: Neil Brown <neilb@suse.de>
Subject: Re: Crash during raid6 reshape, now cannot restart?
Date: Sat, 11 Dec 2010 09:02:53 +1100
Message-ID: <20101211090253.2f2b7a7c@notabene.brown>
References: <AANLkTimk7Ecth7n+qPZ7R-JOAmCmJUJbCTAw3uY8FpPO@mail.gmail.com>
	<20101211074305.5f55c4b4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101211074305.5f55c4b4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Genera <pg@fivesevenfive.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 11 Dec 2010 07:43:05 +1100 Neil Brown <neilb@suse.de> wrote:

> > 
> > raid5: reshape_position too early for auto-recovery - aborting.  
> 
> Something must be going wrong with the math in raid5:
> 
>                if (mddev->delta_disks < 0
>                     ? (here_new * mddev->new_chunk_sectors <=
>                        here_old * mddev->chunk_sectors)
>                     : (here_new * mddev->new_chunk_sectors >=
>                        here_old * mddev->chunk_sectors)) {
>                         /* Reading from the same stripe as writing to - bad */
>                         printk(KERN_ERR "raid5: reshape_position too early for "
>                                "auto-recovery - aborting.\n");
>                         return -EINVAL;
>                 }
> 
> there 'here_new* new_chunk_size' must be over-flowing.  So the size of the
> array must only just fit into sector_t.
> On and arm5 you would need to have CONFIG_LBD set - do you know if it is?
> 
> I guess I need to make that code more robust when sector_t doesn't have lots
> more bits that the size of the device...
> 
> If you can compile your own kernel, you should be able to get it to work
> easily.  If not ... complain to whoever provided you with a kernel.
> 

No ... I take that back.  here_new is the result of dividing the
reshape_position by chunk_sector times number of disks.
So multiplying by chunk_sectors again is not going to cause an overflow.

So I have no idea what if going on here.... maybe a compiler bug?

If you compile your own kernel, I would put some printk's in
drives/md/raid5.c just before the above code to see what the values of the
variables are, and to see what the results of the multiplications will be.

NeilBrown

