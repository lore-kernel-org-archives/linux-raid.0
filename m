From: NeilBrown <neilb@suse.de>
Subject: Re: Question about RAID1 plug/unplug code
Date: Fri, 12 Sep 2014 16:16:49 +1000
Message-ID: <20140912161649.09b2d898@notabene.brown>
References: <CAGRgLy4WTXdF4Tp1pf0BJ-VPR3Yhx_xyzbCAXBzNDpeYTPvkmw@mail.gmail.com>
	<20140909114538.552a4a7d@notabene.brown>
	<CAGRgLy4QAz6KVncLsVypsOD85jMUNaOgrFc13=knHMXb92SvXw@mail.gmail.com>
	<20140909194532.621f4500@notabene.brown>
	<CAGRgLy6iLnxY-gHELBXhd4uymM3CoPVFM5yWdRpQC9Hk7vnf4g@mail.gmail.com>
	<20140910193631.0c8cd1f4@notabene.brown>
	<CAGRgLy6kQmmhgUkMHEhOwjhyLU-0Pn1Gb4j+9VnasaHTTSjgnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/jfKwnpVeBpqnhLovKh9O.al"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6kQmmhgUkMHEhOwjhyLU-0Pn1Gb4j+9VnasaHTTSjgnw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Yair Hershko <yair@zadarastorage.com>
List-Id: linux-raid.ids

--Sig_/jfKwnpVeBpqnhLovKh9O.al
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Sep 2014 11:22:40 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
>=20
> On Wed, Sep 10, 2014 at 12:36 PM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 10 Sep 2014 11:01:30 +0300 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Hello Neil,
> >>
> >> On Tue, Sep 9, 2014 at 12:45 PM, NeilBrown <neilb@suse.de> wrote:
> >> > On Tue, 9 Sep 2014 11:33:13 +0300 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> >> > wrote:
> >> >
> >> >> Hi Neil,
> >> >>
> >> >>
> >> >> On Tue, Sep 9, 2014 at 4:45 AM, NeilBrown <neilb@suse.de> wrote:
> >> >> > On Mon, 8 Sep 2014 16:55:52 +0300 Alexander Lyakas <alex.bolshoy@=
gmail.com>
> >> >> > wrote:
> >> >> >
> >> >> >> Hi Neil,
> >> >> >> We have been seeing high latency on the md/raid1 block device, d=
ue to
> >> >> >> the fact that all WRITEs are handed off to raid1d thread. This t=
hread
> >> >> >> also calls bitmap_unplug(), which writes the bitmap synchronousl=
y.
> >> >> >> While it waits for the bitmap, it cannot trigger other WRITEs wa=
iting
> >> >> >> in its pending_bio_list. This is especially seen with SSDs: MD's
> >> >> >> latency is much higher that SSD latency (I have been stoned by P=
eter
> >> >> >> Grandi when I brought up this issue previously for raid5).
> >> >> >>
> >> >> >> Then I have noticed the commit:
> >> >> >>
> >> >> >> commit f54a9d0e59c4bea3db733921ca9147612a6f292c
> >> >> >> Author: NeilBrown <neilb@suse.de>
> >> >> >> Date:   Thu Aug 2 08:33:20 2012 +1000
> >> >> >>
> >> >> >>     md/raid1: submit IO from originating thread instead of md th=
read.
> >> >> >>
> >> >> >> Looking at the code, I learned that to avoid switching into raid=
1d,
> >> >> >> the caller has to use blk_start_plug/blk_finish_plug. So I added=
 these
> >> >> >> calls in our kernel module, which submits bios to MD. Results we=
re
> >> >> >> awesome, MD latency got down significantly.
> >> >> >
> >> >> > That's good to hear.
> >> >> >
> >> >> >>
> >> >> >> So I have several questions about this plug/unplug thing.
> >> >> >>
> >> >> >> 1/ Originally this infrastructure was supposed to help IO schedu=
lers
> >> >> >> in merging requests. It is useful when one has a bunch of reques=
ts to
> >> >> >> submit in one shot.
> >> >> >
> >> >> > That is exactly the whole point of plugging:  allow the device to=
 handle a
> >> >> > batch of requests together instead of one at a time.
> >> >> >
> >> >> >> But in MD case, thus infrastructure is used for a different purp=
ose:
> >> >> >> not to merge requests (which may help bandwidth, but probably not
> >> >> >> latency), but to avoid making raid1d a bottleneck, to be able to
> >> >> >> submit requests from multiple threads in parallel, which brings =
down
> >> >> >> latency significantly in our case. Indeed "struct blk_plug" has a
> >> >> >> special "cb_list", which is used only by MD.
> >> >> >
> >> >> > I don't think the way md uses plugging is conceptually different =
from any
> >> >> > other use: it is always about gathering a batch together.
> >> >> > "cb_list" is handled by blk_check_plugged() which is also used by
> >> >> > block/umem.c and btrfs.
> >> >> >
> >> >> > The base plugging code assumes that it is only gathering a batch =
of requests
> >> >> > for a single device - if the target device changes then the batch=
 is flushed.
> >> >> > It also assumed that it was "struct request" that was batched.
> >> >> > Devices like md that want to queue 'struct bio', something else w=
as needed.
> >> >> > Also with layered devices it can be useful to gather multiple bat=
ches for
> >> >> > multiple layers.
> >> >> > So I created "cb_list" etc and a more generic interface.
> >> >> >
> >> >> >> In my case I have only individual bios (not a bunch of bios), an=
d I
> >> >> >> after wrap them with plug/unplug, MD latency gets better. So we =
are
> >> >> >> using the plug infrastructure for a different purpose.
> >> >> >> Is my understanding correct? Was this your intention?
> >> >> >
> >> >> > I don't really understand what you are doing.  There is no point =
in using
> >> >> > plugging for individual bios.  The  main point for raid1 writes i=
s to gather
> >> >> > a lot of writes together so that all multiple bitmap bits can be =
set all at
> >> >> > once.
> >> >> > It should be possible to submit individual bios directly from mak=
e_request
> >> >> > without passing them to raid1d and without using plugging.
> >> >> Can you pls explain how it is possible?
> >> >> You have this code for WRITEs:
> >> >>         cb =3D blk_check_plugged(raid1_unplug, mddev, sizeof(*plug)=
);
> >> >>         if (cb)
> >> >>             plug =3D container_of(cb, struct raid1_plug_cb, cb);
> >> >>         else
> >> >>             plug =3D NULL;
> >> >>         spin_lock_irqsave(&conf->device_lock, flags);
> >> >>         if (plug) {
> >> >>             bio_list_add(&plug->pending, mbio);
> >> >>             plug->pending_cnt++;
> >> >>         } else {
> >> >>             bio_list_add(&conf->pending_bio_list, mbio);
> >> >>             conf->pending_count++;
> >> >>         }
> >> >>         spin_unlock_irqrestore(&conf->device_lock, flags);
> >> >>
> >> >> If the thread blk_check_plugged returns NULL, then you always hand =
the
> >> >> WRITE to raid1d. So the only option to avoid handoff to raid1d is f=
or
> >> >> the caller to plug. Otherwise, all WRITEs are handed off to raid1d =
and
> >> >> latency becomes terrible.
> >> >> So in my case, I use plug/unplug for individual bios only to avoid =
the
> >> >> handoff to raid1d.
> >> >> What am I missing in this analysis?
> >> >
> >> > if blk_check_plugged succeeds then it has arranged for raid1_unplug =
to be
> >> > called a little later by that same process.
> >> > So there is nothing to stop you calling raid1_unplug immediately.
> >> >
> >> > raid1_unplug essentially does:
> >> >   bitmap_unplug()
> >> >   generic_make_request()
> >> >
> >> > so you can very nearly just do that, without any plugging.
> >> I am sorry, but I did not understand your reply. Maybe I did not
> >> explain myself, I will try again.
> >>
> >> I am not changing raid1.c code. I just want to avoid the handoff to
> >> raid1d on WRITEs. According to your code, there are only two possible
> >> flows:
> >>
> >> Flow 1 - with plugging
> >> # caller calls blk_start_plug
> >> # caller calls submit_bio
> >> # blk_check_plugged succeeds, and bio is put onto plug->pending list
> >> # caller calls blk_finish_plug
> >> # raid1_unplug is called in the same caller's thread, so it does
> >> bitmap_unplug and generic_make_request
> >>
> >> Flow 2 - without plugging
> >> # caller calls submit_bio
> >> # blk_check_plugged fails, and bio is put onto conf->pending_bio_list,
> >> which means it will be submitted by raid1d
> >>
> >> My conclusion from that: to avoid the handoff to raid1, caller always
> >> need to plug, even if it has a single bio to submit. But you said "it
> >> should be possible to submit individual bios directly from
> >> make_request without passing them to raid1d and without using
> >> plugging". So can you explain how it is possible? I prefer not to
> >> change raid1.c code.
> >>
> >> >
> >> > There is a bit of extra subtlety but I can't really know how relevan=
t that
> >> > might be to you without actually seeing you code.
> >> My code (in a different kernel module, not in raid1.c) is simply doing
> >> submit_bio. I want to wrap this with plug/unplug to avoid the handoff
> >> to raid1d and improve raid1 latency.
> >>
> >
> > I think I need to see the code you are working with to be able to sugge=
st
> > anything used.
> I am working with kernel 3.8.13. But your master branch has the same
> code with respect to plug/unplug logic.
>=20
> > But if it works with plugging, then just do it that way(?).
> It works perfectly, and latency is much better. The only doubt is with
> bitmap_unplug being called from multiple threads now. However, it can
> happen for anybody that uses plug/unplug on top of MD raid1 (like ext4
> for example). So question is whether it is safe for MD users to
> plug/unplug when submitting bios to MD. If not, would you be fixing
> this?

Didn't I already answer that question?

  Date: Tue, 9 Sep 2014 11:45:38 +1000

  Hmmm... there could be an issue there.  It is possible that some callers =
of
  bitmap_unplug won't block when they should.  bitmap_unplug should probably
  wait unconditionally.

See
http://git.neil.brown.name/?p=3Dmd.git;a=3Dcommitdiff;h=3D339f60d943f848eb5=
16aa4b82b5e187dbbe088dc

(not tested yet).

NeilBrown


>=20
> Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/jfKwnpVeBpqnhLovKh9O.al
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBKP0Tnsnt1WYoG5AQL8IRAAin097Bz+k44PACzyWR0MPkl+j3n4d2OF
qnqAiiW8ysLEztyt9l1z+toRBPm9YDXH5D3ZxDTC7IM8uTPpramjTTfRCqfGTIVG
3mD1brVFnwf/yAgXuLL5SS7p4Sd3wftkh7enC8AVw4w9IpbicjZXY5gppjTpfuA0
ox3WiGmOr1Xho/aqf1Qc9eRXfhzQsDRvBi/qhYSmJ4tKj2EMvWHuBLUdGVQN1LtS
VGfY85VLyPUjKfA8WLWIprV3Uq2ZSP8NshlHOwX/IHbAp4A1XsGqY6dKXB+0d5tA
6mwd4rGidoZ6vuoRNyYSlCIz8f9pInD6POdxekxRS/b1wWLicTU/riQyaSEJQ8p5
2CnSravfyGQ6uwgjL2rCI15L1R1rYDj0Q0hJ17m64zmVIe1P9l0m3GNiJgdiRtI7
eUaw3u0IGfmMj7n2JGF5eG8q4oG4SkV2ZdeGhM+d+hTIF4UbVcNudnBvk17ZDIli
g7pFFF8zYOtIw6ekueLTYWbF6wAB32Y3l/vrLgKMQhmWqkuNC3ldWc+1nh6tirV8
X3XpDEwPsXPdcpyhbPaO16H5Zay9rBh0Zk7SJKsL7COtZVImg2dNOpM4ztCA+WJO
OhrAU6HpN5a0jCoBNlUqxuGXlw6sS5NtMapx35LOvMhHQYvPO47KeCiUZUmLOeM6
ZYk2twLttzc=
=OBTe
-----END PGP SIGNATURE-----

--Sig_/jfKwnpVeBpqnhLovKh9O.al--
