From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/2] raid1/10: Handle write errors correctly in narrow_write_error()
Date: Thu, 22 Oct 2015 11:59:05 -0400
Message-ID: <wrfjpp06lws6.fsf@redhat.com>
References: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com>
	<87pp092sid.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87pp092sid.fsf@notabene.neil.brown.name> (Neil Brown's message
	of "Wed, 21 Oct 2015 07:29:30 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, William.Kuzeja@stratus.com, xni@redhat.com, nate.dailey@stratus.com
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
>
> Thanks to both of you!
>
> I took the liberty of changing the patches a little so they are now:
>
> -               if (submit_bio_wait(WRITE, wbio) == 0)
> +               if (submit_bio_wait(WRITE, wbio) < 0)
>
> because when there is no explicit test I tend to expect a Bool but these
> values are not Bool.
>
> Patches are in my for-linus branch and will be forwarded sometime this
> week.
>
> This bug only causes a problem when bad-block logs are active, so
> hopefully it won't have caused too much corruption yet -- you would need
> to be using a newish mdadm.

Neil,

An additional twist on this one - Nate ran more tests on this, but was
still able to hit data corruption. He suggests the it is a mistake to
set 'ok = rdev_set_badblocks()' and it should instead be set to 0 if
submit_bio_wait() fails. Like this:

--- raid1.c
+++ raid1.c
@@ -2234,11 +2234,12 @@
 		bio_trim(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_sector += rdev->data_offset;
 		wbio->bi_bdev = rdev->bdev;
 		if (submit_bio_wait(WRITE, wbio) < 0) {
 			/* failure! */
-			ok = rdev_set_badblocks(rdev, sector,
-						sectors, 0)
-				&& ok;
+			ok = 0;
+			rdev_set_badblocks(rdev, sector,
+					   sectors, 0);
+		}

Question is whether this change has any negative impact in case of a
real write failure?

I have actual patches, I'll send as a reply to this one.

Cheers,
Jes
