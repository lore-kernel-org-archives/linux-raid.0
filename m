From: NeilBrown <neilb@suse.de>
Subject: Re: potentially lost largeish raid5 array..
Date: Sun, 25 Sep 2011 20:10:25 +1000
Message-ID: <20110925201025.53bc87f7@notabene.brown>
References: <201109221950.36910.tfjellstrom@shaw.ca>
	<20110923151108.08c1199f@notabene.brown>
	<201109222322.57040.tfjellstrom@shaw.ca>
	<201109230209.36209.thomas@fjellstrom.ca>
	<20110923191539.110b7be1@notabene.brown>
	<4E7E5266.5040205@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RTV.FQZ/8GWv3kScDrb0Bx="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7E5266.5040205@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Aapo Laine <aapo.laine@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/RTV.FQZ/8GWv3kScDrb0Bx=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Sep 2011 23:57:58 +0200 Aapo Laine <aapo.laine@shiftmail.org>
wrote:

> On 09/23/11 11:15, NeilBrown wrote:
> > On Fri, 23 Sep 2011 02:09:36 -0600 Thomas Fjellstrom<thomas@fjellstrom.=
ca>
> > wrote:
> >> I forgot to say, but: Thank you very much :) for the help, and your ti=
reless
> >> work on md.
> >>
> >
> > You've very welcome .... but I felt I needed to respond to that word
> > "tireless".
> > The truth is that I am getting rather tired of md .... if anyone knows =
anyone
> > who wants to get into kernel development and is wondering where to star=
t -
> > please consider whispering 'the md driver' in their ear.  Plenty to do,=
 great
> > mentoring possibilities, and competent linux kernel engineers with good
> > experience are unlikely to have much trouble finding a job ;-)
> >
> > NeilBrown
>=20
> Whoa this is shocking news!

Hopefully not too shocking...  I'm not planning on leaving md any time soon.
I do still enjoy working on it.
But it certainly isn't as fresh and new as it was 10 years again.  It would
probably do both me and md a lot of good to have someone with new enthusiasm
and new perspectives...


>=20
> Firstly then, thank you so much for your excellent work up to now. Linux=
=20
> has what I believe to be the best software raid of all operating systems=
=20
> thanks to you. Excellent in both features, and reliability i.e. quality=20
> of code.
>=20
> And also the support through the list was great. I found so many=20
> problems solved already just by looking at the archives... so many=20
> people with their arse saved by you.
>=20
> I think everybody here is sorry to see you willing to go.
>=20
> Now the bad news... Regarding the MD takeover, there I think I see a=20
> problem...
> The MD code is very tersely commented, compared to its complexity!

That is certainly true, but seems to be true across much of the kernel, and
probably most code in general (though I'm sure such a comment will lead to
people wanting to tell me their favourite exceptions ... so I'll start with
"TeX").

This is one of the reasons I offered "mentoring" to any likely candidate.



>=20
> - there is not much explanation of overall strategies, or the structure=20
> of code. Also the flow of data between the functions is not much=20
> explained most of the times.
>=20
> - It's not obvious to me what is the entry point for kernel processes=20
> related to MD arrays, how are they triggered and where do they run...=20
> E.g. in the past I tried to understand how did resync work, but I=20
> couldn't. I thought there was a kernel process controlling resync=20
> advancement, but I couldn't really find the boundaries of code inside=20
> which it was executing.

md_do_sync() is the heart of the resync process.  it calls into the
personality's sync_request() function.

The kernel thread is started by md_check_recovery() if it appears to be
needed.  md_check_recovery() is regularly run by each personality's main
controlling thread.

>=20
> - it's not clear what the various functions do or in what occasion they=20
> are called. Except from their own name, most of them have no comments=20
> just before the definition.

How about this:
 - you identify some functions for which the purpose or use isn't clear
 - I'll explain to you when/how/why they are used
 - You create a patch which adds comments which explains it all
 - I'll apply that patch.

deal??

>=20
> - the algoritms within the functions are very long and complex, but only=
=20
> rarely they are explained by comments. I am now seeing pieces having 5=20
> levels of if's nested one inside the other, and there are almost no=20
> comments.

I feel your pain.   I really should factor out the deeply nested levels into
separate functions.  Sometimes I have done that but there is plenty more do
to.  Again, I would be much more motivated to do this if I were working with
someone who would be directly helped by it.  So if you identify specific
problems, it'll be a lot easier for me to help fix them.


>=20
> - last but not least, variables have very short names, and for most of=20
> them, it is not explained what they mean. This is mostly for local=20
> variables, but sometimes even for the structs which go into metadata=20
> e.g. in struct r1_private_data_s most members do not have an=20
> explanation. This is pretty serious, to me at least, for understanding=20
> the code.

Does this help?

diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index e0d676b..feb44ad 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -28,42 +28,67 @@ struct r1_private_data_s {
 	mddev_t			*mddev;
 	mirror_info_t		*mirrors;
 	int			raid_disks;
+
+	/* When choose the best device for a read (read_balance())
+	 * we try to keep sequential reads one the same device
+	 * using 'last_used' and 'next_seq_sect'
+	 */
 	int			last_used;
 	sector_t		next_seq_sect;
+	/* During resync, read_balancing is only allowed on the part
+	 * of the array that has been resynced.  'next_resync' tells us
+	 * where that is.
+	 */
+	sector_t		next_resync;
+
 	spinlock_t		device_lock;
=20
+	/* list of 'r1bio_t' that need to be processed by raid1d, whether
+	 * to retry a read, writeout a resync or recovery block, or
+	 * anything else.
+	 */
 	struct list_head	retry_list;
-	/* queue pending writes and submit them on unplug */
-	struct bio_list		pending_bio_list;
=20
-	/* for use when syncing mirrors: */
+	/* queue pending writes to be submitted on unplug */
+	struct bio_list		pending_bio_list;
=20
+	/* for use when syncing mirrors:
+	 * We don't allow both normal IO and resync/recovery IO at
+	 * the same time - resync/recovery can only happen when there
+	 * is no other IO.  So when either is active, the other has to wait.
+	 * See more details description in raid1.c near raise_barrier().
+	 */
+	wait_queue_head_t	wait_barrier;
 	spinlock_t		resync_lock;
 	int			nr_pending;
 	int			nr_waiting;
 	int			nr_queued;
 	int			barrier;
-	sector_t		next_resync;
-	int			fullsync;  /* set to 1 if a full sync is needed,
-					    * (fresh device added).
-					    * Cleared when a sync completes.
-					    */
-	int			recovery_disabled; /* when the same as
-						    * mddev->recovery_disabled
-						    * we don't allow recovery
-						    * to be attempted as we
-						    * expect a read error
-						    */
=20
-	wait_queue_head_t	wait_barrier;
+	/* Set to 1 if a full sync is needed, (fresh device added).
+	 * Cleared when a sync completes.
+	 */
+	int			fullsync
=20
-	struct pool_info	*poolinfo;
+	/* When the same as mddev->recovery_disabled we don't allow
+	 * recovery to be attempted as we expect a read error.
+	 */
+	int			recovery_disabled;
=20
-	struct page		*tmppage;
=20
+	/* poolinfo contains information about the content of the
+	 * mempools - it changes when the array grows or shrinks
+	 */
+	struct pool_info	*poolinfo;
 	mempool_t *r1bio_pool;
 	mempool_t *r1buf_pool;
=20
+	/* temporary buffer to synchronous IO when attempting to repair
+	 * a read error.
+	 */
+	struct page		*tmppage;
+
+
 	/* When taking over an array from a different personality, we store
 	 * the new thread here until we fully activate the array.
 	 */

>=20
> - ... maybe more I can't think of right now ...
>=20
> Your code is of excellent quality, as I wrote, I wish there were more=20
> programmers like you, but if you now want to leave, THEN I start to be=20
> worried! Would you please comment it (much) more before leaving? Fully=20
> understanding your code I think is going to take other people a lot of=20
> time otherwise, and you might not find a replacement easily and/or s/he=20
> might do mistakes.

I'm not planning on leaving - not for quite some time anyway.
But I know the code so well that it is hard to see which bits need
documenting, and what sort of documentation would really help.
I would love it if you (or anyone) would review the code and point to parts
that particularly need improvement.


>=20
> There were times in the past when I had ideas and I wanted to contribute=
=20
> code, but when I looked inside MD and tried to understand where should I=
=20
> put my changes, I realized I wasn't able to understand what current code=
=20
> was doing. Maybe I am not a good enough C programmer, but I was able to=20
> change things in other occasions.

Don't be afraid to ask... But sometimes you do need a bit of persistence
though. :-)  Not always easy to find time for that.


>=20
>=20
> I hope you won't get these critiques bad...

Not at all.

> and thanks for all your efforts, really, in the name of, I think, everybo=
dy.
> Aapo L.

Thanks for your valuable feedback.
Being able to see problems is of significant value.  One of the reasons that
I pay close attention to this list is because it shows me where the problems
with md and mdadm are.  People often try things that I would never even dre=
am
of trying (because I know they won't work).  See this helps me know where t=
he
code and be improved - either so what they try does work, or so it fails mo=
re
gracefully and helpfully.

Thanks,
NeilBrown

--Sig_/RTV.FQZ/8GWv3kScDrb0Bx=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOfv4RG5fc6gV+Wb0RAmu2AJ45eaEcwdoE/iICar3iEcCuVLd40ACgj9A1
tQCAhfrSo0//oOuG/4UKaoc=
=Soyx
-----END PGP SIGNATURE-----

--Sig_/RTV.FQZ/8GWv3kScDrb0Bx=--
