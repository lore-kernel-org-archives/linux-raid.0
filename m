From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: high throughput storage server?
Date: Tue, 22 Mar 2011 11:14:03 +0100
Message-ID: <20110322101403.GA9329@www2.open-std.org>
References: <4D837DAF.6060107@hardwarefreak.com> <20110319090101.1786cc2a@notabene.brown> <4D8559A2.6080209@hardwarefreak.com> <20110320144147.29141f04@notabene.brown> <AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com> <4D868C36.5050304@hardwarefreak.com> <20110321024452.GA23100@www2.open-std.org> <4D875E51.50807@hardwarefreak.com> <20110321221304.GA900@www2.open-std.org> <20110322094658.GA21078@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110322094658.GA21078@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Stan Hoeppner <stan@hardwarefreak.com>, Mdadm <linux-raid@vger.kernel.org>, Roberto Spadim <roberto@spadim.com.br>, NeilBrown
List-Id: linux-raid.ids

On Tue, Mar 22, 2011 at 09:46:58AM +0000, Robin Hill wrote:
> On Mon Mar 21, 2011 at 11:13:04 +0100, Keld J=F8rn Simonsen wrote:
>=20
> > On Mon, Mar 21, 2011 at 09:18:57AM -0500, Stan Hoeppner wrote:
> > >=20
> > > > Anyway, with 384 spindles and only 50 users, each user will hav=
e in
> > > > average 7 spindles for himself. I think much of the time this w=
ould mean=20
> > > > no random IO, as most users are doing large sequential reading.=
=20
> > > > Thus on average you can expect quite close to striping speed if=
 you
> > > > are running RAID capable of striping.=20
> > >=20
> > > This is not how large scale shared RAID storage works under a
> > > multi-stream workload.  I thought I explained this in sufficient =
detail.
> > >  Maybe not.
> >=20
> > Given that the whole array system is only lightly loaded, this is h=
ow I
> > expect it to function. Maybe you can explain why it would not be so=
, if
> > you think otherwise.
> >=20
> If you have more than one system accessing the array simultaneously t=
hen
> your sequential IO immediately becomes random (as it'll interleave th=
e
> requests from the multiple systems). The more systems accessing
> simultaneously, the more random the IO becomes. Of course, there will
> still be an opportunity for some readahead, so it's not entirely rand=
om
> IO.

Of course the IO will be randomized, if there is more users, but the
read IO will tend to be quite sequential, if the reading of each proces=
s
is sequential. So if a user reads a big file sequentially, and the
system is lightly loaded, IO schedulers will tend to order all IO
for the process so that it is served in one series of operations,
given that the big file is laid out consequently on the file system.

> > it is probably not the concurrency of XFS that makes the parallelis=
m of
> > the IO. It is more likely the IO system, and that would also work f=
or
> > other file system types, like ext4. I do not see anything in the XF=
S allocation
> > blocks with any knowledge of the underlying disk structure.=20
> > What the file system does is only to administer the scheduling of t=
he
> > IO, in combination with the rest of the kernel.

> XFS allows for splitting the single filesystem into multiple allocati=
on
> groups. It can then allocate blocks from each group simultaneously
> without worrying about collisions. If the allocation groups are on
> separate physical spindles then (apart from the initial mapping of a
> request to an allocation group, which should be a very quick operatio=
n),
> the entire write process is parallelised.  Most filesystems have only=
 a
> single allocation group, so the block allocation is single threaded a=
nd
> can easily become a bottleneck. It's only once the blocks are allocat=
ed
> (assuming the filesystem knows about the physical layout) that the
> writes can be parallelised. I've not looked into the details of ext4
> though, so I don't know whether it makes any moves towards parallelis=
ing
> block allocation.

The block allocation is only done when writing. The system at hand was
specified as a mostly reading system, where such a bottleneck of block
allocating is not so dominant.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
