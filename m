From: NeilBrown <neilb@suse.de>
Subject: Re: potentially lost largeish raid5 array..
Date: Mon, 7 Nov 2011 08:58:39 +1100
Message-ID: <20111107085839.1002aaeb@notabene.brown>
References: <201109221950.36910.tfjellstrom@shaw.ca>
	<20110923151108.08c1199f@notabene.brown>
	<201109222322.57040.tfjellstrom@shaw.ca>
	<201109230209.36209.thomas@fjellstrom.ca>
	<20110923191539.110b7be1@notabene.brown>
	<4E7E5266.5040205@shiftmail.org>
	<20110925201025.53bc87f7@notabene.brown>
	<CAGRgLy4StFZwkm1VeC36ZV=FEPXo3k_85b5MB==Df2QRp8nJ+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cE7fKqng9ZR+Xckz9BuPZI_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4StFZwkm1VeC36ZV=FEPXo3k_85b5MB==Df2QRp8nJ+Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: Aapo Laine <aapo.laine@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/cE7fKqng9ZR+Xckz9BuPZI_
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 5 Nov 2011 14:17:50 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> I wanted to ask how the mentoring you're willing to offer would work,
> on your opinion?

Primarily you asking questions and me answering them as helpfully as I can.
Also you proposing patches and me giving useful review, and/or queuing them
for upstream.

It could also involve me suggesting things you could work on, but I think
people are more motivated to work on things they have chosen themselves, so=
 I
don't expect that would be a large part of it.

> I had much fun developing for that *other* operating system kernel,
> and I am looking forward to do things for Linux kernel too some day.

Great!

>=20
> My pain at present, is the lack of kernel printouts during various
> config sequences. I have been trying to follow, for example, the
> ADD_NEW_DISK sequence and the slot_store() sequence, to understand how
> it detects whether a full-sync or not will be required. And there are
> many possibilities before you figure out the right "if"
> (non-persistent arrays, containers, external metadata....).
>=20
> I am used to heavily print-around all config (non-IO-path) sequences
> (such as ADD_NEW_DISK). This also helps if a particular step in the
> sequence takes a long time, due to a slow IO or something like that.
> What will be the pros/cons of doing that in md on your opinion?

I think you are suggesting adding more pr_debug() calls in md.c.  Is that
correct?  I don't object to that - they are fairly cheap and can easily be
compiled out completely for those who don't want them.  So feel free to send
me a patch adding some pr_debug's that you find useful, and I'll let you kn=
ow
what I think of them.

NeilBrown


>=20
> Thanks!
> Alex.
>=20
>=20
>=20
> On Sun, Sep 25, 2011 at 12:10 PM, NeilBrown <neilb@suse.de> wrote:
> > On Sat, 24 Sep 2011 23:57:58 +0200 Aapo Laine <aapo.laine@shiftmail.org>
> > wrote:
> >
> >> On 09/23/11 11:15, NeilBrown wrote:
> >> > On Fri, 23 Sep 2011 02:09:36 -0600 Thomas Fjellstrom<thomas@fjellstr=
om.ca>
> >> > wrote:
> >> >> I forgot to say, but: Thank you very much :) for the help, and your=
 tireless
> >> >> work on md.
> >> >>
> >> >
> >> > You've very welcome .... but I felt I needed to respond to that word
> >> > "tireless".
> >> > The truth is that I am getting rather tired of md .... if anyone kno=
ws anyone
> >> > who wants to get into kernel development and is wondering where to s=
tart -
> >> > please consider whispering 'the md driver' in their ear. =A0Plenty t=
o do, great
> >> > mentoring possibilities, and competent linux kernel engineers with g=
ood
> >> > experience are unlikely to have much trouble finding a job ;-)
> >> >
> >> > NeilBrown
> >>
> >> Whoa this is shocking news!
> >
> > Hopefully not too shocking... =A0I'm not planning on leaving md any tim=
e soon.
> > I do still enjoy working on it.
> > But it certainly isn't as fresh and new as it was 10 years again. =A0It=
 would
> > probably do both me and md a lot of good to have someone with new enthu=
siasm
> > and new perspectives...
> >
> >
> >>
> >> Firstly then, thank you so much for your excellent work up to now. Lin=
ux
> >> has what I believe to be the best software raid of all operating syste=
ms
> >> thanks to you. Excellent in both features, and reliability i.e. quality
> >> of code.
> >>
> >> And also the support through the list was great. I found so many
> >> problems solved already just by looking at the archives... so many
> >> people with their arse saved by you.
> >>
> >> I think everybody here is sorry to see you willing to go.
> >>
> >> Now the bad news... Regarding the MD takeover, there I think I see a
> >> problem...
> >> The MD code is very tersely commented, compared to its complexity!
> >
> > That is certainly true, but seems to be true across much of the kernel,=
 and
> > probably most code in general (though I'm sure such a comment will lead=
 to
> > people wanting to tell me their favourite exceptions ... so I'll start =
with
> > "TeX").
> >
> > This is one of the reasons I offered "mentoring" to any likely candidat=
e.
> >
> >
> >
> >>
> >> - there is not much explanation of overall strategies, or the structure
> >> of code. Also the flow of data between the functions is not much
> >> explained most of the times.
> >>
> >> - It's not obvious to me what is the entry point for kernel processes
> >> related to MD arrays, how are they triggered and where do they run...
> >> E.g. in the past I tried to understand how did resync work, but I
> >> couldn't. I thought there was a kernel process controlling resync
> >> advancement, but I couldn't really find the boundaries of code inside
> >> which it was executing.
> >
> > md_do_sync() is the heart of the resync process. =A0it calls into the
> > personality's sync_request() function.
> >
> > The kernel thread is started by md_check_recovery() if it appears to be
> > needed. =A0md_check_recovery() is regularly run by each personality's m=
ain
> > controlling thread.
> >
> >>
> >> - it's not clear what the various functions do or in what occasion they
> >> are called. Except from their own name, most of them have no comments
> >> just before the definition.
> >
> > How about this:
> > =A0- you identify some functions for which the purpose or use isn't cle=
ar
> > =A0- I'll explain to you when/how/why they are used
> > =A0- You create a patch which adds comments which explains it all
> > =A0- I'll apply that patch.
> >
> > deal??
> >
> >>
> >> - the algoritms within the functions are very long and complex, but on=
ly
> >> rarely they are explained by comments. I am now seeing pieces having 5
> >> levels of if's nested one inside the other, and there are almost no
> >> comments.
> >
> > I feel your pain. =A0 I really should factor out the deeply nested leve=
ls into
> > separate functions. =A0Sometimes I have done that but there is plenty m=
ore do
> > to. =A0Again, I would be much more motivated to do this if I were worki=
ng with
> > someone who would be directly helped by it. =A0So if you identify speci=
fic
> > problems, it'll be a lot easier for me to help fix them.
> >
> >
> >>
> >> - last but not least, variables have very short names, and for most of
> >> them, it is not explained what they mean. This is mostly for local
> >> variables, but sometimes even for the structs which go into metadata
> >> e.g. in struct r1_private_data_s most members do not have an
> >> explanation. This is pretty serious, to me at least, for understanding
> >> the code.
> >
> > Does this help?
> >
> > diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> > index e0d676b..feb44ad 100644
> > --- a/drivers/md/raid1.h
> > +++ b/drivers/md/raid1.h
> > @@ -28,42 +28,67 @@ struct r1_private_data_s {
> > =A0 =A0 =A0 =A0mddev_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *mddev;
> > =A0 =A0 =A0 =A0mirror_info_t =A0 =A0 =A0 =A0 =A0 *mirrors;
> > =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 raid_disks;
> > +
> > + =A0 =A0 =A0 /* When choose the best device for a read (read_balance())
> > + =A0 =A0 =A0 =A0* we try to keep sequential reads one the same device
> > + =A0 =A0 =A0 =A0* using 'last_used' and 'next_seq_sect'
> > + =A0 =A0 =A0 =A0*/
> > =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 last_used;
> > =A0 =A0 =A0 =A0sector_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0next_seq_sect;
> > + =A0 =A0 =A0 /* During resync, read_balancing is only allowed on the p=
art
> > + =A0 =A0 =A0 =A0* of the array that has been resynced. =A0'next_resync=
' tells us
> > + =A0 =A0 =A0 =A0* where that is.
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 sector_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0next_resync;
> > +
> > =A0 =A0 =A0 =A0spinlock_t =A0 =A0 =A0 =A0 =A0 =A0 =A0device_lock;
> >
> > + =A0 =A0 =A0 /* list of 'r1bio_t' that need to be processed by raid1d,=
 whether
> > + =A0 =A0 =A0 =A0* to retry a read, writeout a resync or recovery block=
, or
> > + =A0 =A0 =A0 =A0* anything else.
> > + =A0 =A0 =A0 =A0*/
> > =A0 =A0 =A0 =A0struct list_head =A0 =A0 =A0 =A0retry_list;
> > - =A0 =A0 =A0 /* queue pending writes and submit them on unplug */
> > - =A0 =A0 =A0 struct bio_list =A0 =A0 =A0 =A0 pending_bio_list;
> >
> > - =A0 =A0 =A0 /* for use when syncing mirrors: */
> > + =A0 =A0 =A0 /* queue pending writes to be submitted on unplug */
> > + =A0 =A0 =A0 struct bio_list =A0 =A0 =A0 =A0 pending_bio_list;
> >
> > + =A0 =A0 =A0 /* for use when syncing mirrors:
> > + =A0 =A0 =A0 =A0* We don't allow both normal IO and resync/recovery IO=
 at
> > + =A0 =A0 =A0 =A0* the same time - resync/recovery can only happen when=
 there
> > + =A0 =A0 =A0 =A0* is no other IO. =A0So when either is active, the oth=
er has to wait.
> > + =A0 =A0 =A0 =A0* See more details description in raid1.c near raise_b=
arrier().
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 wait_queue_head_t =A0 =A0 =A0 wait_barrier;
> > =A0 =A0 =A0 =A0spinlock_t =A0 =A0 =A0 =A0 =A0 =A0 =A0resync_lock;
> > =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_pending;
> > =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_waiting;
> > =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_queued;
> > =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 barrier;
> > - =A0 =A0 =A0 sector_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0next_resync;
> > - =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fullsync; =A0=
/* set to 1 if a full sync is needed,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 * (fresh device added).
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 * Cleared when a sync completes.
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 */
> > - =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 recovery_disa=
bled; /* when the same as
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * mddev->recovery_disabled
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * we don't allow recovery
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * to be attempted as we
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * expect a read error
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> >
> > - =A0 =A0 =A0 wait_queue_head_t =A0 =A0 =A0 wait_barrier;
> > + =A0 =A0 =A0 /* Set to 1 if a full sync is needed, (fresh device added=
).
> > + =A0 =A0 =A0 =A0* Cleared when a sync completes.
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fullsync
> >
> > - =A0 =A0 =A0 struct pool_info =A0 =A0 =A0 =A0*poolinfo;
> > + =A0 =A0 =A0 /* When the same as mddev->recovery_disabled we don't all=
ow
> > + =A0 =A0 =A0 =A0* recovery to be attempted as we expect a read error.
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 recovery_disa=
bled;
> >
> > - =A0 =A0 =A0 struct page =A0 =A0 =A0 =A0 =A0 =A0 *tmppage;
> >
> > + =A0 =A0 =A0 /* poolinfo contains information about the content of the
> > + =A0 =A0 =A0 =A0* mempools - it changes when the array grows or shrinks
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 struct pool_info =A0 =A0 =A0 =A0*poolinfo;
> > =A0 =A0 =A0 =A0mempool_t *r1bio_pool;
> > =A0 =A0 =A0 =A0mempool_t *r1buf_pool;
> >
> > + =A0 =A0 =A0 /* temporary buffer to synchronous IO when attempting to =
repair
> > + =A0 =A0 =A0 =A0* a read error.
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 struct page =A0 =A0 =A0 =A0 =A0 =A0 *tmppage;
> > +
> > +
> > =A0 =A0 =A0 =A0/* When taking over an array from a different personalit=
y, we store
> > =A0 =A0 =A0 =A0 * the new thread here until we fully activate the array.
> > =A0 =A0 =A0 =A0 */
> >
> >>
> >> - ... maybe more I can't think of right now ...
> >>
> >> Your code is of excellent quality, as I wrote, I wish there were more
> >> programmers like you, but if you now want to leave, THEN I start to be
> >> worried! Would you please comment it (much) more before leaving? Fully
> >> understanding your code I think is going to take other people a lot of
> >> time otherwise, and you might not find a replacement easily and/or s/he
> >> might do mistakes.
> >
> > I'm not planning on leaving - not for quite some time anyway.
> > But I know the code so well that it is hard to see which bits need
> > documenting, and what sort of documentation would really help.
> > I would love it if you (or anyone) would review the code and point to p=
arts
> > that particularly need improvement.
> >
> >
> >>
> >> There were times in the past when I had ideas and I wanted to contribu=
te
> >> code, but when I looked inside MD and tried to understand where should=
 I
> >> put my changes, I realized I wasn't able to understand what current co=
de
> >> was doing. Maybe I am not a good enough C programmer, but I was able to
> >> change things in other occasions.
> >
> > Don't be afraid to ask... But sometimes you do need a bit of persistence
> > though. :-) =A0Not always easy to find time for that.
> >
> >
> >>
> >>
> >> I hope you won't get these critiques bad...
> >
> > Not at all.
> >
> >> and thanks for all your efforts, really, in the name of, I think, ever=
ybody.
> >> Aapo L.
> >
> > Thanks for your valuable feedback.
> > Being able to see problems is of significant value. =A0One of the reaso=
ns that
> > I pay close attention to this list is because it shows me where the pro=
blems
> > with md and mdadm are. =A0People often try things that I would never ev=
en dream
> > of trying (because I know they won't work). =A0See this helps me know w=
here the
> > code and be improved - either so what they try does work, or so it fail=
s more
> > gracefully and helpfully.
> >
> > Thanks,
> > NeilBrown
> >


--Sig_/cE7fKqng9ZR+Xckz9BuPZI_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrcDDznsnt1WYoG5AQKCeA//Qj7jNZGPHu4oG3wTbixNY2dxP3WhFWL/
gRj87jPeqzUtKed57+rWEtTSpGVuUOrhTB6h5KQ6lAbWZSmCSYmQ9d3zJYk91+h/
xRnErgumBVhtzWHmSPqoftN8dpKAt18rJ9p5cBG0TnzuRou+8Sz1HFG/Qk7se/mW
lNTamUe2sIKDT1c9Lo9TutVyxlZSbOAfLNrQeGl4AUOpOZldJ3DCk3bcX8L5+C6a
uuYCmlXYJvQMnz7rZN7We4aRC9jGo/JwuXwVjjF6d1/SfvC/RORneATg3LvrHjji
TMXlRaBzAi1X6yFZUTAXJ1mjE4oFry8tY53tYAb08Nv49afbneigORvE3yDtN+XW
IKOTYIPKTVDBuyGY7svzgme7eKQ7H2gXK2lW8TdCpy6ldgGJ3Uy/qSi4BPRYhFLA
IKUyjRbhqd9/iCPIe6gLja4iZKqzQ5sw/WfRyY41atNWRZ8LJyW+XfGI9MWFQczH
Hivm0eBb+IXWUbSIN7WylOpVgokoPGHvl6jAU/SGQhft/pXiYCtj/3swv3vdvp3A
2HcEOTKT5+Fa3AMOIrMilEiEQ+UtJrmlxtf5Yv+54fGse6OlbaO3hR61YC34yX5F
dG53eUvHi43r3VsKlsBi0a6mbZvf2KXsOEIimz6yBaZNeshRMDuHoDqbFaudXaEv
5S3Bmx/7gDE=
=4eLk
-----END PGP SIGNATURE-----

--Sig_/cE7fKqng9ZR+Xckz9BuPZI_--
