From: NeilBrown <neilb@suse.de>
Subject: Re: [patch v2]raid5: fix directio regression
Date: Tue, 11 Sep 2012 10:44:44 +1000
Message-ID: <20120911104444.1e13320c@notabene.brown>
References: <CANejiEUQcA6X75WG0xSgSv6NAQaBQnwpDD-5QaNVbqmo-oqLsA@mail.gmail.com>
	<201208071421033759628@gmail.com>
	<CANejiEVoOprAFoS6mCVYDJKh+nbGE0=7Xw_CpVS+Z9AcUoh6RQ@mail.gmail.com>
	<201208081321202343795@gmail.com>
	<CANejiEWC5ZKWT2L4DM-bfGi+v=TpkABruQqe5h0qG4oQg9sDhw@mail.gmail.com>
	<201208090919591567972@gmail.com>
	<20120809113230.152aade3@notabene.brown>
	<CANejiEX1TKG_KhAsgUauHaCe2GE7jU1ozD-3c21VFgrm9COajQ@mail.gmail.com>
	<20120814063343.GA30353@kernel.org>
	<20120815105610.74fe418e@notabene.brown>
	<20120815014436.GA355@kernel.org>
	<201208161536313436886@gmail.com>
	<CANejiEU7dD+VMLidGQZ4OpCTcsOXReExeA-Qtr5Ng9DRGU5Geg@mail.gmail.com>
	<CANejiEXCytsYB1ruO0pHcYdkPXBwvkY3uQT36=M=VwRR_ibf4g@mail.gmail.com>
	<201208231446557815641@gmail.com>
	<CANejiEU3fG2fAGTE2m47zxy0p9MykHTEDznRKxbUcFReZgVG3g@mail.gmail.com>
	<201208232017099682142@gmail.com>
	<CANejiEWxbUL-NHXtxMXd8i2oNwo6tNGTep2TVVay=7gjkOavqg@mail.gmail.com>
	<201208241221216404240@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8D9gn_SIQUON9dDoXciRUQP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201208241221216404240@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: shli <shli@kernel.org>, majianpeng <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

--Sig_/8D9gn_SIQUON9dDoXciRUQP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Aug 2012 12:21:30 +0800 kedacomkernel <kedacomkernel@gmail.com>
wrote:

> On 2012-08-24 11:12 Shaohua Li <shli@kernel.org> Wrote:
> >2012/8/23 Jianpeng Ma <majianpeng@gmail.com>:
> >> On 2012-08-23 15:55 Shaohua Li <shli@kernel.org> Wrote:
> >>>2012/8/23 Jianpeng Ma <majianpeng@gmail.com>:
> >>>> On 2012-08-23 14:08 Shaohua Li <shli@kernel.org> Wrote:
> >>>>>2012/8/16 Shaohua Li <shli@kernel.org>:
> >>>>>> 2012/8/16 Jianpeng Ma <majianpeng@gmail.com>:
> >>>>>>> On 2012-08-15 09:44 Shaohua Li <shli@kernel.org> Wrote:
> >>>>>>>>On Wed, Aug 15, 2012 at 10:56:10AM +1000, NeilBrown wrote:
> >>>>>>>>> On Tue, 14 Aug 2012 14:33:43 +0800 Shaohua Li <shli@kernel.org>=
 wrote:
> >>>>>>>>>
> >>>>>>>>> > On Thu, Aug 09, 2012 at 01:07:01PM +0800, Shaohua Li wrote:
> >>>>>>>>> > > 2012/8/9 NeilBrown <neilb@suse.de>:
> >>>>>>>>> > > > On Thu, 9 Aug 2012 09:20:05 +0800 "Jianpeng Ma" <majianpe=
ng@gmail.com> wrote:
> >>>>>>>>> > > >
> >>>>>>>>> > > >> On 2012-08-08 20:53 Shaohua Li <shli@kernel.org> Wrote:
> >>>>>>>>> > > >> >2012/8/8 Jianpeng Ma <majianpeng@gmail.com>:
> >>>>>>>>> > > >> >> On 2012-08-08 10:58 Shaohua Li <shli@kernel.org> Wrot=
e:
> >>>>>>>>> > > >> >>>2012/8/7 Jianpeng Ma <majianpeng@gmail.com>:
> >>>>>>>>> > > >> >>>> On 2012-08-07 13:32 Shaohua Li <shli@kernel.org> Wr=
ote:
> >>>>>>>>> > > >> >>>>>2012/8/7 Jianpeng Ma <majianpeng@gmail.com>:
> >>>>>>>>> > > >> >>>>>> On 2012-08-07 11:22 Shaohua Li <shli@kernel.org> =
Wrote:
> >>>>>>>>> > > >> >>>>>>>My directIO randomwrite 4k workload shows a 10~20=
% regression caused by commit
> >>>>>>>>> > > >> >>>>>>>895e3c5c58a80bb. directIO usually is random IO an=
d if request size isn't big
> >>>>>>>>> > > >> >>>>>>>(which is the common case), delay handling of the=
 stripe hasn't any advantages.
> >>>>>>>>> > > >> >>>>>>>For big size request, delay can still reduce IO.
> >>>>>>>>> > > >> >>>>>>>
> >>>>>>>>> > > >> >>>>>>>Signed-off-by: Shaohua Li <shli@fusionio.com>
> >>>>>>>>> > > >> >>>> [snip]
> >>>>>>>>> > > >> >>>>>>>--
> >>>>>>>>> > > >> >>>>>> May be used size to judge is not a good method.
> >>>>>>>>> > > >> >>>>>> I firstly sended this patch, only want to control=
 direct-write-block,not for reqular file.
> >>>>>>>>> > > >> >>>>>> Because i think if someone used direct-write-bloc=
k for raid5,he should know the feature of raid5 and he can control
> >>>>>>>>> > > >> >>>>>> for write to full-write.
> >>>>>>>>> > > >> >>>>>> But at that time, i did know how to differentiate=
 between regular file and block-device.
> >>>>>>>>> > > >> >>>>>> I thik we should do something to do this.
> >>>>>>>>> > > >> >>>>>
> >>>>>>>>> > > >> >>>>>I don't think it's possible user can control his wr=
ite to be a
> >>>>>>>>> > > >> >>>>>full-write even for
> >>>>>>>>> > > >> >>>>>raw disk IO. Why regular file and block device io m=
atters here?
> >>>>>>>>> > > >> >>>>>
> >>>>>>>>> > > >> >>>>>Thanks,
> >>>>>>>>> > > >> >>>>>Shaohua
> >>>>>>>>> > > >> >>>> Another problem is the size. How to judge the size =
is large or not?
> >>>>>>>>> > > >> >>>> A syscall write is a dio and a dio may be split mor=
e bios.
> >>>>>>>>> > > >> >>>> For my workload, i usualy write chunk-size.
> >>>>>>>>> > > >> >>>> But your patch is judge by bio-size.
> >>>>>>>>> > > >> >>>
> >>>>>>>>> > > >> >>>I'd ignore workload which does sequential directIO, t=
hough
> >>>>>>>>> > > >> >>>your workload is, but I bet no real workloads are. So=
 I'd like
> >>>>>>>>> > > >> >> Sorry,my explain maybe not corcrect. I write data onc=
e which size is almost chunks-size * devices,in order to full-write
> >>>>>>>>> > > >> >> and as possible as to no pre-read operation.
> >>>>>>>>> > > >> >>>only to consider big size random directio. I agree th=
e size
> >>>>>>>>> > > >> >>>judge is arbitrary. I can optimize it to be only cons=
ider stripe
> >>>>>>>>> > > >> >>>which hits two or more disks in one bio, but not sure=
 if it's
> >>>>>>>>> > > >> >>>worthy doing. Not ware big size directio is common, a=
nd even
> >>>>>>>>> > > >> >>>is, big size request IOPS is low, a bit delay maybe n=
ot a big
> >>>>>>>>> > > >> >>>deal.
> >>>>>>>>> > > >> >> If add a acc_time for 'striep_head' to control?
> >>>>>>>>> > > >> >> When get_active_stripe() is ok, update acc_time.
> >>>>>>>>> > > >> >> For some time, stripe_head did not access and it shol=
d pre-read.
> >>>>>>>>> > > >> >
> >>>>>>>>> > > >> >Do you want to add a timer for each stripe? This is eve=
n ugly.
> >>>>>>>>> > > >> >How do you choose the expire time? A time works for har=
ddisk
> >>>>>>>>> > > >> >definitely will not work for a fast SSD.
> >>>>>>>>> > > >> A time is like the size which is arbitrary.
> >>>>>>>>> > > >> How about add a interface in sysfs to control by user?
> >>>>>>>>> > > >> Only user can judge the workload, which sequatial write =
or random write.
> >>>>>>>>> > > >
> >>>>>>>>> > > > This is getting worse by the minute.  A sysfs interface f=
or this is
> >>>>>>>>> > > > definitely not a good idea.
> >>>>>>>>> > > >
> >>>>>>>>> > > > The REQ_NOIDLE flag is a pretty clear statement that no m=
ore requests that
> >>>>>>>>> > > > merge with this one are expected.  If some use cases send=
s random requests,
> >>>>>>>>> > > > maybe it should be setting REQ_NOIDLE.
> >>>>>>>>> > > >
> >>>>>>>>> > > > Maybe someone should do some research and find out why WR=
ITE_ODIRECT doesn't
> >>>>>>>>> > > > include REQ_NOIDLE.  Understanding that would help unders=
tand the current
> >>>>>>>>> > > > problem.
> >>>>>>>>> > >
> >>>>>>>>> > > A quick search shows only cfq-iosched uses REQ_NOIDLE. In
> >>>>>>>>> > > cfq, a queue is idled to avoid losing its share. REQ_NOIDLE
> >>>>>>>>> > > tells cfq to avoid idle, since the task will not dispatch f=
urther
> >>>>>>>>> > > requests any more. Note this isn't no merge.
> >>>>>>>>> >
> >>>>>>>>> > Since REQ_NOIDLE has no relationship with request merge, we'd=
 better remove it.
> >>>>>>>>> > I came out a new patch, which doesn't depend on request size =
any more. With
> >>>>>>>>> > this patch, sequential directio will still introduce unnecess=
ary raid5 preread
> >>>>>>>>> > (especially for small size IO), but I bet no app does sequent=
ial small size
> >>>>>>>>> > directIO.
> >>>>>>>>> >
> >>>>>>>>> > Thanks,
> >>>>>>>>> > Shaohua
> >>>>>>>>> >
> >>>>>>>>> > Subject: raid5: fix directio regression
> >>>>>>>>> >
> >>>>>>>>> > My directIO randomwrite 4k workload shows a 10~20% regression=
 caused by commit
> >>>>>>>>> > 895e3c5c58a80bb. This commit isn't friendly for small size ra=
ndom IO, because
> >>>>>>>>> > delaying such request hasn't any advantages.
> >>>>>>>>> >
> >>>>>>>>> > DirectIO usually is random IO. I thought we can ignore reques=
t merge between
> >>>>>>>>> > bios from different io_submit. So we only consider one bio wh=
ich can drive
> >>>>>>>>> > unnecessary preread in raid5, which is large request. If a bi=
o is large enough
> >>>>>>>>> > and some of its stripes will access two or more disks, such s=
tripes should be
> >>>>>>>>> > delayed to avoid unnecessary preread till bio for the last di=
sk of the strips
> >>>>>>>>> > is added.
> >>>>>>>>> >
> >>>>>>>>> > REQ_NOIDLE doesn't mean about request merge, I deleted it.
> >>>>>>>>>
> >>>>>>>>> Hi,
> >>>>>>>>>  Have you tested what effect this has on large sequential direc=
t writes?
> >>>>>>>>>  Because it don't make sense to me and I would be surprised if =
it improves
> >>>>>>>>>  things.
> >>>>>>>>>
> >>>>>>>>>  You are delaying setting the STRIPE_PREREAD_ACTIVE bit until y=
ou think you
> >>>>>>>>>  have submitted all the writes from this bio that apply to the =
give stripe.
> >>>>>>>>>  That does make some sense, however it doesn't seem to deal wit=
h the
> >>>>>>>>>  possibility that the one bio covers parts of two different str=
ipes.  In that
> >>>>>>>>>  case the first stripe never gets STRIPE_PREREAD_ACTIVE set, so=
 it is delayed
> >>>>>>>>>  despite having 'REQ_SYNC' set.
> >>>>>>>>
> >>>>>>>>I didn't get your point. Isn't last_sector - logical_sector < chu=
nk_sectors true
> >>>>>>>>in the case?
> >>>>>>>>
> >>>>>>>>>  Also, and more significantly, plugging should mean that the va=
rious
> >>>>>>>>>  stripe_heads are not even looked at until all of the original =
bio is
> >>>>>>>>>  processed, so while STRIPE_PREREAD_ACTIVE might get set early,=
 it should not
> >>>>>>>>>  get processed until the whole bio is processed and the queue i=
s unplugged.
> >>>>>>>>>
> >>>>>>>>>  So I don't think this patch should make a difference on large =
direct writes,
> >>>>>>>>>  and if it does then something strange is going on that I'd lik=
e to
> >>>>>>>>>  understand first.
> >>>>>>>>
> >>>>>>>>Aha, ok, this makes sense. recent delayed stripe release should m=
ake the
> >>>>>>>>problem go away. So Jianpeng, can you try your workload with the =
commit
> >>>>>>>>reverted with a recent kernel please?
> >>>>>>>>
> >>>>>>> I tested used your patch in my workload.
> >>>>>>> Like the neil said, the performance does not regress.
> >>>>>>> But if the code is :
> >>>>>>>>                       if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->s=
tate))
> >>>>>>>>                               release_stripe(sh);
> >>>>>>>>                       else
> >>>>>>>>                               release_stripe_plug(mddev, sh);
> >>>>>>> The speed is about 76MB/s.With those code the speed is 200MB/s.
> >>>>>>
> >>>>>> Hmm, what I want to test is upstream kernel with commit 895e3c5c58=
a80bb
> >>>>>> reverted. don't apply my patch. We want to just revert the commit.
> >>>>>
> >>>>>Did you have data for your original workload with 895e3c5c58a80bb
> >>>>>reverted now?
> >>>> our raid5 which had 14 SATA HDDs.
> >>>>
> >>>> with  895e3c5c58a80bb reverted:
> >>>> using dd to test 55MB/s
> >>>> using our-fs 200-250Mb/s
> >>>>
> >>>> with  895e3c5c58a80bb:
> >>>> using dd to test 275MB/s
> >>>> using our-fs 500-550Mb/s
> >>>
> >>>what's block size of dd in this test? In your original test, your
> >>>BS covers chunk_sector*data_disks. In that case,
> >>>895e3c5c58a80bb is likely not required.
> >>>
> >> With latest kernel(3.6-rc3), w/ or w/o 895e3c5c58a80bb, the result is =
the same.
> >> The block size of dd is chunk_sector * data_disks.
> >> Your patch(8811b5968f6216e97) is good.
> >> I think it shoul revert 8811b5968f6216e97.
> >
> >revert 895e3c5c58a80bb, right?
> yes. Because the 8811b5968f6216e97, it can revert.

Thanks.  I've reverted 895e3c5c58a80bb and will submit to -next later today.

NeilBrown

--Sig_/8D9gn_SIQUON9dDoXciRUQP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE6JfDnsnt1WYoG5AQLSgQ//ShFfXNVYz2Kna0Z65NUN3vxYFG0UvF3M
UTbcqNMMQJPyvPAfjik8nHblAvGHqg+udxry6yuI+iVNbEwt0ndOEh5cUtSzviXA
nBdKvlaRRKQ8cWh1141BFcZ4ytGcR7Bat1lPbVar6c/RMbBT6eDcqT4KKTtp57PB
WrEAKah7YOdxms/qsMecbmlUQs6tAwvAs5ENfiLX0tsBUVld9dG3/wCHYRUtJQ9A
gcOeOmcVXSxTMk9cewi/mbfEpqgE/ZK8uWXX8lP9oMTEYVyZVbrKErPhB7m9VEMO
5xJ7DiQi08YelLaByvYX30Vlf/BvdJejp+jsmiNS6Zj+zdOPUwXijXIqwTsF4qQN
sfyFBpO+IG6O2nxytRL0njbva5NIbJV/z7A7pu6Pw1f0lIooeV707YT2mCMsxVR+
ZGOUWS9w8dMjSpnfsRRkLCuA9SwVtraqttZehfNNoNCR238jiqt+xgUThSMO2WOv
/szPqjK6zBfwtfkQYS2IgRgyFSbDYEl87IYK8Z2mzb9Jt5Ivj/YHWgAJ7YLFEEgU
snP0JScK65EkVcsaGW7AecjnKLXvnX7Vf5aZzAeUdLGvMT0aIItx5Cy5XL7oYHPk
tDwxOgyA0NwN30qEbGOPsr+CdldnKhxgUMeYW5oDpbf+FfpdxzNU40V/zo1kznEw
8ja0ZmIkRVA=
=v1US
-----END PGP SIGNATURE-----

--Sig_/8D9gn_SIQUON9dDoXciRUQP--
