From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 16:01:44 -0500
Message-ID: <87f94c370911101301v4b71ce74hbd4ebd20e7ce2419@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	 <yq1ljienxql.fsf@sermon.lab.mkp.net>
	 <f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
	 <yq11vk6nnrh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq11vk6nnrh.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Worley <worleys@gmail.com>, "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 3:11 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Chris" =3D=3D Chris Worley <worleys@gmail.com> writes:
>
<snip>
>
> Chris> And I do appreciate all your work. =A0I fear, in this case, di=
scard
> Chris> will be optimized for the slower technology... we won't be
> Chris> getting all that's available from it.
>
> Discard isn't "optimized" for anything. =A0It's a command. =A0Filesys=
tem
> issues it, it gets sent to the storage device (DSM/TRIM, WRITE SAME, =
or
> UNMAP depending on target type).
>

Martin,

I'm not sure that is right, but Chris is also wrong.

I'm not sure where it ended up, but the big SSD / discard discussion
of a few months ago talked about 3 kinds of solutions, and I thought
the plan was to support all 3.

1) optimization 1 - A white-listed instant discard feature.  In this
methodology, the filesystems would immediately send discard calls down
to the block layer would send them on down the block stack to the
physical devices with very minimal buffering.  It was thought high-end
Intel SSDs would benefit from this model.  It also sounds like SSS
devices would benefit from this per Chris's comments.

Note that this approach is NOT very friendly from a raid 4/5/6
approach.  Those raid levels need to discard full stripes at a time,
so getting a large number of small discards would be painful.

2) optimization 2 - The block layer would accept those small discards,
but accumulate them for a short period.  (less than a second was my
impression).  Then coalesce them into larger discards and send them
down the block stack and eventually to the physical device.

This is slightly better from a raid 4/5/6 perspective, but I suspect
the discard ranges would still be too small.

3) optimization 3 -  a background freespace scanner would run from
time to time that scanned a filesystem for free blocks and send a
discard / trim command down to the device.  This is what Mark Lord was
working on.  His solution was primarily in user space and was
controlled by cron.

I believe this is by far the best approach for a raid 4/5/6
implementation, but at the time Mark's implementation was bypassing
the block stack and using SG_IO to directly talk to the physical
devices.  I don't recall any discussion of how MD could participate in
the process.  Thus Mark's solution at the time was not compatible with
md raid 4/5/6 implementations.

Since this is the mdraid mailing list, maybe someone can tell us which
of the above are getting the attention of md devels and if there is
any ongoing effort to support them?

Thanks
Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
