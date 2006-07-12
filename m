From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: only 4 spares and no access to my data
Date: Wed, 12 Jul 2006 21:35:45 +0200
Message-ID: <62b0912f0607121235v5146eafbx84a877899e965c94@mail.gmail.com>
References: <loom.20060709T205013-455@post.gmane.org>
	 <loom.20060710T095111-275@post.gmane.org>
	 <44B213CD.5010907@idgmail.se>
	 <loom.20060710T112944-980@post.gmane.org>
	 <62b0912f0607100416v51309355v693b5c83ee51fdbc@mail.gmail.com>
	 <loom.20060710T132722-427@post.gmane.org>
	 <62b0912f0607100507s21544d12xec9a8bf117b6edc2@mail.gmail.com>
	 <loom.20060710T142912-798@post.gmane.org>
	 <62b0912f0607101006k6f9e66cfp86d4f0d0c1de4a3a@mail.gmail.com>
	 <loom.20060710T211030-179@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20060710T211030-179@post.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Karl Voit <news@karl-voit.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Karl Voit wrote:
> if (super == NULL) {
>   fprintf(stderr, Name ": No suitable drives found for %s\n", mddev);
> [...]
>
> Well I guess, the message will be shown, if the superblock is not found.

Yes.  No clue why, my buest guess is that you've already zeroed the superblock.
What does madm --query / --examine say about /dev/sd[abcd], are there
superblocks ?

> st = guess_super(fd);
>   if (st == NULL) {
>     if (!quiet)
>       fprintf(stderr, Name ": Unrecognised md component device - %s\n",
> dev);
>
> Again: this seems to be the case, when the superblock is empty.

Yes, looks like it can't find any usable superblocks.
Maybe you've accidentally zeroed the superblocks on sd[abcd]1 also?

If you fdisk -l /dev/sd[abcd], does the partition tables look like
they should / like they used to?

What does mdadm --query / --examine /dev/sd[abcd]1 tell you, any superblocks ?

> Since my miserably failure I am probably too careful *g*
>
> The problem is also, that without deeper background knowledge, I can not
> predict, if this or that permanently affects the real data on the disks.

My best guess is that it's OK and you won't loose data if you run
--zero-superblock on /dev/sd[abcd] and then create an array on
/dev/sd[abcd]1, but I do find it odd that it suddenly can't find
superblocks on /dev/sd[abcd]1.

> Maybe such a person like me starts to think that sw-raid-tools like
> mdadm should warn users before permanent changes are executed. If
> mdadm should be used by users (additional to raid-geeks like you),
> it might be a good idea to prevent data loss. (Ment as a suggestion.)

Perhaps.  Or perhaps mdadm should just tell you that you're doing
something stupid if you try to manipulate arrays on a block device
which seems to contain a partition table.

It's not like it's even remotely useful to create an MD array spanning
the whole disk rather than spanning a partition which spans the whole
disk, anyway.
