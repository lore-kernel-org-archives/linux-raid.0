From: Neil Brown <neilb@suse.de>
Subject: Re: RAID scrubbing
Date: Thu, 15 Apr 2010 11:22:06 +1000
Message-ID: <20100415112206.6fcd3d3f@notabene.brown>
References: <q2s150c16851004091828t235d2derf36033d19e2f11ad@mail.gmail.com>
	<l2t4877c76c1004091841n40a6ad69gb9f73c9d1b68f4ae@mail.gmail.com>
	<s2y150c16851004091846t94347cf8u9ffd65133061d16b@mail.gmail.com>
	<h2m4877c76c1004091901k37443583h316eb0efacbcac80@mail.gmail.com>
	<w2h150c16851004141751w6d798c12k548527dab7420db4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <w2h150c16851004141751w6d798c12k548527dab7420db4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 14 Apr 2010 17:51:11 -0700
Justin Maggard <jmaggard10@gmail.com> wrote:

> On Fri, Apr 9, 2010 at 7:01 PM, Michael Evans <mjevans1983@gmail.com>=
 wrote:
> > On Fri, Apr 9, 2010 at 6:46 PM, Justin Maggard <jmaggard10@gmail.co=
m> wrote:
> >> On Fri, Apr 9, 2010 at 6:41 PM, Michael Evans <mjevans1983@gmail.c=
om> wrote:
> >>> On Fri, Apr 9, 2010 at 6:28 PM, Justin Maggard <jmaggard10@gmail.=
com> wrote:
> >>>> Hi all,
> >>>>
> >>>> I've got a system using two RAID5 arrays that share some physica=
l
> >>>> devices, combined using LVM. =C2=A0Oddly, when I "echo repair >
> >>>> /sys/block/md0/md/sync_action", once it finishes, it automatical=
ly
> >>>> starts a repair on md1 also, even though I haven't requested it.
> >>>> Also, if I try to stop it using "echo idle >
> >>>> /sys/block/md0/md/sync_action", a repair starts on md1 within a =
few
> >>>> seconds. =C2=A0If I stop that md1 repair immediately, sometimes =
it will
> >>>> respawn and start doing the repair again on md1. =C2=A0What shou=
ld I be
> >>>> expecting here? =C2=A0If I start a repair on one array, is it su=
pposed to
> >>>> automatically go through and do it on all arrays sharing that
> >>>> personality?
> >>>>
> >>>> Thanks!
> >>>> -Justin
> >>>>
> >>>
> >>> Is md1 degraded with an active spare? =C2=A0It might be delaying =
resync on
> >>> it until the other devices are idle.
> >>
> >> No, both arrays are redundant. =C2=A0I'm just trying to do scrubbi=
ng
> >> (repair) on md0; no resync is going on anywhere.
> >>
> >> -Justin
> >>
> >
> > First: Reply to all.
> >
> > Second, if you insist that things are not as I suspect:
> >
> > cat /proc/mdstat
> >
> > mdadm -Dvvs
> >
> > mdadm -Evvs
> >
>=20
> I insist it's something different. :)  Just ran into it again on
> another system.  Here's the requested output:

Thanks.  Very thorough!


> Apr 14 17:32:23 JMAGGARD kernel: md: requested-resync of RAID array m=
d2
> Apr 14 17:32:23 JMAGGARD kernel: md: minimum _guaranteed_  speed: 100=
0
> KB/sec/disk.
> Apr 14 17:32:23 JMAGGARD kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for requested-resync.
> Apr 14 17:32:23 JMAGGARD kernel: md: using 128k window, over a total
> of 972041296 blocks.
> Apr 14 17:32:51 JMAGGARD kernel: md: md_do_sync() got signal ... exit=
ing
> Apr 14 17:33:35 JMAGGARD kernel: md: requested-resync of RAID array m=
d3

So we see the requested-resync (repair) of md2 started as you requested=
,
then finished at 17:32:51 when you write 'idle' to 'sync_action'.

Then 44 seconds later a similar repair started on md3.
44 seconds is too long for it to be a direct consequence of the md2 rep=
air
stopping.  Something *must* have written to md3/md/sync_action.   But w=
hat?

Maybe you have "mdadm --monitor" running and it notices when repair on =
one
array finished and has been told to run a script (--program or PROGRAM =
in
mdadm.conf) which would then start a repair on the next array???

Seems a bit far-fetched, but I'm quite confident that some program must=
 be
writing to md3/md/sync_action while you're not watching.

NeilBrown


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
