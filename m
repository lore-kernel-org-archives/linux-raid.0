From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: "Robust Read"
Date: Sat, 19 Mar 2005 23:30:58 +0100
Message-ID: <2qlug2-snu.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it> <423B4C4B.7070404@tls.msk.ru> <9phtg2-6c1.ln1@news.it.uc3m.es> <423C1C58.1090609@tls.msk.ru> <vvjtg2-t16.ln1@news.it.uc3m.es> <423C4E62.4070704@tls.msk.ru> <gj2ug2-9q3.ln1@news.it.uc3m.es> <423C897B.1030100@tls.msk.ru> <19gug2-0bj.ln1@news.it.uc3m.es> <423CA21F.9060503@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> The point a) is moot, because this whole structure is used in raid1.c=
 ONLY.
> (I don't know why it is placed into raid1.h header file instead of in=
to
> raid1.c directly, but that's a different topic).

Hmm. I'm a little surprised. I would be worried that it had escaped
somewhere.

> > Maybe if you were to use the existing "remaining" field for the bir=
map,
> > you would get rid of objection (a)! :-). You could even rename it v=
ia a
> > #define :-).
>=20
> atomic_t has its own API, it can't be used for &=3D and |=3D operatio=
ns for
> example.

Ah - was the remaining field atomic_t, then? But one can use it - at
least in i386. I recall there are bit ops. Yes. Atomic.h

/* These are x86-specific, used by some header files */
#define atomic_clear_mask(mask, addr) \
__asm__ __volatile__(LOCK =E4ndl %0,%1" \
: : "r" (~(mask)),"m" (*addr) : "memory")

#define atomic_set_mask(mask, addr) \
__asm__ __volatile__(LOCK =F6rl %0,%1" \
: : "r" (mask),"m" (*(addr)) : "memory")

I also seem to recall "writing" equivalents for sparc - where I think
they were just the ordinary ops.

But take no notice.

> >>BTW, what's the reason to use raid1d for retries in the first place=
?
> >>Why not just resubmit the request in reschedule_retry() directly,
> >>the same way it is done in raid1d?
> >=20
> > No reason that I recall.  Isn't raid1d going to do it offline?  You=
 want
> > to do it sync instead?  Anyway, the rerite code is completely
> > uninvestigated, so please try anything you like!
>=20
> I asked about retrying failed read, not about re-writes.
>=20

Sorry - I wasn't following too closely because of a conversation with
Lars, and I wan't looking at my original patch, so .... but as I
recall, the failed read is retried with reschedule_retry(), since
that's what happens when the flow falls out the bottom of the patch int
the remainder of the raid1_end_read_request() code, after an
not-uptdate request is seen.

        /*
         * we have only one bio on the read side
         */
        if (uptodate
#ifdef CONFIG_MD_RAID1_ROBUST_READ
                /* Give up and error if we're last */
                || atomic_dec_and_test(&r1_bio->remaining)
#endif /* CONFIG_MD_RAID1_ROBUST_READ */
                )
#ifdef DO_ADD_READ_WRITE_CORRECT
                if (uptodate && test_bit(R1BIO_ReadRetry, &r1_bio->stat=
e)) {
                        /* Success at last - rewrite failed reads */
                        set_bit(R1BIO_IsSync, &r1_bio->state);
                        reschedule_retry(r1_bio);
                } else
#endif /* DO_ADD_READ_WRITE_CORRECT */
                        raid_end_bio_io(r1_bio);
        else {
                /*
                 * oops, read error:
                 */
                char b[BDEVNAME_SIZE];
                if (printk_ratelimit())
                        printk(KERN_ERR "raid1: %s: rescheduling sector=
 %llu\n",
                               bdevname(conf->mirrors[mirror].rdev->bde=
v,b), (un
signed long long)r1_bio->sector);
                reschedule_retry(r1_bio);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^ here
        }


Or do you mean "skip the r_r call and do what it would do instead"?
Well, that would broaden the patch cross-section here at least.

What r_r does is just place things on the retry list, and shout:

  list_add(&r1_bio->retry_list, &retry_list_head);
  md_wakeup_thread(mddev->thread);

The raid1d thread on the read side apears to redirect the bio, when it
pics it up, and resubmit it:

    r1_bio->read_disk =3D disk; // we chose this with map()
    ...
    bio =3D bio_clone(r1_bio->master_bio, GFP_NOIO);
    ...
    generic_make_request(bio);

I don't see why one shouldn't take advantage of all that code. It
didn't need altering.

I only had to add a little bit on the write side.


> []
> >>>>+       r1_bio->tried_disks =3D 0;
> >>>
> >>>Hmm. Ditto. I suppose we are making the read request here. Yes we =
are.
> >>>I had set the "remaining" count instead.
>=20
> Note in your version you have a chance to request a read from
> first disk again, in case you have some failed/missing disks.

I don't think so - unless you suspect a race condition between retrying
and changing the config. One can forget that - the worst that can
happen is that we try the same disk again and fail again, which will
ultimately lead to an error return. But the admin deserves it for
changing config while a request is busy failing and looking for new
disks to try :-).  I wouldn't go solving likely very rare problems at
this stage until the problem turns out to have significance. Leave a
comment in the code if you see the problem.


> So i think that instead of usage of "remaining" field, it's better
> to remember the disk from which we did the first read, and loop
> over all disks up to the first one.

That's a possibility too, but as I said, getting things wrong is not
disastrous! We can't do worse that what happened without the patch. If
you like, try "n+1" times instead  of "n" times, and that should make
real sure! Keep it simple.

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
