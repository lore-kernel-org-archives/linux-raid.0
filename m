From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid1 repair: sync_request() aborts if one of the drives has bad
 block recorded
Date: Tue, 31 Jul 2012 08:56:31 +0300
Message-ID: <CAGRgLy5aSMywZ9Q5AsmTnZgj3hV19UoCiEzsELnztAiPesqMdA@mail.gmail.com>
References: <CAGRgLy6j3pEeXGXJbVc4Sz3gdShWWfaT7hyXnurgO-6N-_E_ZA@mail.gmail.com>
	<20120716133753.1a34e149@notabene.brown>
	<CAGRgLy6JZXiHFg11Z-_3krj8iKp_Wk7X_wz8OyikyvhLpxzcxg@mail.gmail.com>
	<20120717111753.178d53d5@notabene.brown>
	<CAGRgLy6jDTGXu1Yk2tCnHKDVTfCKjA2P6L-qgrD8EcPb8gCaBA@mail.gmail.com>
	<CAGRgLy5FXG9gFgq+QR_OknhNVtEMuSj6d-Hso5PYcjaD2rzXcQ@mail.gmail.com>
	<20120731121141.109cbfd6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120731121141.109cbfd6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for letting me know, Neil. I already know that I just have to
be patient, and eventually you will attend.
Thanks!
Alex.

On Tue, Jul 31, 2012 at 5:11 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 24 Jul 2012 22:30:33 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>> apparently you decided not to apply that patch?
>
> No, worse than that.  I marked your email as 'needs attention'.  That appears
> to be an almost-certain guarantee that I'll never look at it again - must be
> a bug in my brain.  Apologies.
>
>> On Tue, Jul 17, 2012 at 4:17 PM, Alexander Lyakas
>> <alex.bolshoy@gmail.com> wrote:
>> > Thanks for your comments, I got confused with the REQUESTED bit.
>> > I prepared the patch, with couple of notes:
>> >
>> > 1/ I decided to be more careful and schedule a write only in case of
>> > resync or repair. I was not sure whether we should try to correct bad
>> > blocks on device X, when device Y is recovering. Pls change it if you
>> > feel otherwise.
>
> That looks sensible.  I've left it as it is.
>
>> >
>> > 2/ I tested and committed the patch on top of ubuntu-precise 3.2.0-25.
>> > I looked at your "for-next" branch, and saw that there is some new
>> > code, which handles hot-replace, which I am not familiar with at this
>> > point.
>
> It shouldn't make any important change to this patch.
> For RAID1, hot-replace just means there can be twice as many devices as you
> would expect.
>
>
>> >
>> > Final note: I noticed that badblocks_show() fails if there are too
>> > many bad blocks. It returns value larger than PAGE_SIZE, and then the
>> > following linux code complains:
>> > fs/sysfs/file.c:fill_read_buffer()
>> >         /*
>> >          * The code works fine with PAGE_SIZE return but it's likely to
>> >          * indicate truncated result or overflow in normal use cases.
>> >          */
>> >         if (count >= (ssize_t)PAGE_SIZE) {
>> >                 print_symbol("fill_read_buffer: %s returned bad count\n",
>> >                         (unsigned long)ops->show);
>> >                 /* Try to struggle along */
>> >                 count = PAGE_SIZE - 1;
>> >         }
>> >
>> > So I am not sure how to solve it, but it would be good for
>> > user/application to receive the full list of bad blocks. Perhaps
>> > application can pass fd via some ioctl (I feel you don't like ioctls),
>> > and then kernel can use vfs_write() to print all the bad blocks to the
>> > fd. Or simply return the bad blocks list through the ioctl output to
>> > mdadm, and mdadm would print them. Perhaps some other way.
>
> It isn't possible to get a full list of bad blocks from sysfs, much as it is
> not possible to read the write-intent-bitmap or other metadata.
>
> The main purpose for the two bad-blocks files in sysfs is to allow a
> user-space metadata manager (mdmon) to find out when the kernel discovers a
> bad block, to record in the metadata, and then to acknowledge it.
> It is always possible to read the first entry from
> the unacknowledged_bad_blocks file, then acknowledge it and so remove it from
> the list, and in that way you can get all unacknowledged bad blocks.
> Acknowledged bad blocks will be listed in the metadata already.
>
> Still... I should probably fix the code so that it never displays a partial
> truncated number, but stops before PAGE_SIZE..
>
>
> Thanks,
> NeilBrown
>
>
