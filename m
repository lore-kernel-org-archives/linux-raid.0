From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/2] raid1/10: Handle write errors correctly in narrow_write_error()
Date: Tue, 20 Oct 2015 19:12:41 -0400
Message-ID: <wrfjvba1xhg6.fsf@redhat.com>
References: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com>
	<87pp092sid.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87pp092sid.fsf@notabene.neil.brown.name> (Neil Brown's message
	of "Wed, 21 Oct 2015 07:29:30 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, kent.overstreet@gmail.com, William.Kuzeja@stratus.com, xni@redhat.com
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:
> Jes.Sorensen@redhat.com writes:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Hi,
>>
>> Bill Kuzeja reported a problem to me about data corruption when
>> repeatedly removing and re-adding devices in raid1 arrays. It showed
>> up to be caused by the return value of submit_bio_wait() being handled
>> incorrectly. Tracking this down is credit of Bill!
>>
>> Looks like commit 9e882242c6193ae6f416f2d8d8db0d9126bd996b changed the
>> return of submit_bio_wait() to return != 0 on error, whereas before it
>> returned 0 on error.
>>
>> This fix should be suitable for -stable as far back as 3.9
>
> 3.10?

Yes, I guess there is no 3.9 stable, but certainly 3.10+

> Thanks to both of you!
>
> I took the liberty of changing the patches a little so they are now:
>
> -               if (submit_bio_wait(WRITE, wbio) == 0)
> +               if (submit_bio_wait(WRITE, wbio) < 0)
>
> because when there is no explicit test I tend to expect a Bool but these
> values are not Bool.

I based it on this from block/bio.c:

/**
 * submit_bio_wait - submit a bio, and wait until it completes
 * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
 * @bio: The &struct bio which describes the I/O
 *
 * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
 * bio_endio() on failure.
 */

assuming anything but 0 is an error, but < 0 should be fine as well.

> Patches are in my for-linus branch and will be forwarded sometime this
> week.

Sounds great!

Thanks!
Jes
