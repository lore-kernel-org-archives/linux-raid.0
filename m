From: Andy Smith <andy@strugglers.net>
Subject: Re: grub-probe: "found two disks with the index 3 for RAID md2"
 after changing superblock 0.9 to 1.0
Date: Tue, 16 Sep 2014 04:00:24 +0000
Message-ID: <20140916040023.GG27492@bitfolk.com>
References: <20140915064741.GH11855@bitfolk.com>
 <20140915170037.16f93daa@notabene.brown>
 <20140915171252.GI11855@bitfolk.com>
 <20140916075458.155ca17a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140916075458.155ca17a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Tue, Sep 16, 2014 at 07:54:58AM +1000, NeilBrown wrote:
> On Mon, 15 Sep 2014 17:12:52 +0000 Andy Smith <andy@strugglers.net> w=
rote:
> > On Mon, Sep 15, 2014 at 05:00:37PM +1000, NeilBrown wrote:
> > >   mdadm --zero-super --metadata=3D0.90 /dev/sda3
> > >=20
> > > will remove any 0.90 metadata.
> >=20
> > Trying that whole the array is running:
> >=20
> > mdadm: Couldn't open /dev/sda3 for write - not zeroing
> >=20
> > This needs to be done with the array stopped, presumably?
>=20
> It's preferred, but if you are really confident (and I think you are)=
, then
> adding --force is justified and should make it work.

Yep, that worked, thank you! No more complaints from grub-probe.

Do you consider it a bug that mdadm does not zero the old metadata
when upgrading it to a new version?

Or do you consider it a documentation issue to explain that it may
be necessary to manually do it?

I think I would've liked grub-probe at least in verbose mode to say
which version of metadata it was reading from where. That would've
been immediately enlightening, so I'll see if they would accept a
patch for that=E2=80=A6

Cheers,
Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
