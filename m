From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: raid 5 out of sync won't mount
Date: Tue, 18 Jun 2002 18:56:38 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020618165638.GA11713@unthought.net>
References: <3D0F4799.5090403@fullmonty.org> <20020618161549.GA17321@colombina.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020618161549.GA17321@colombina.comedia.it>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 18, 2002 at 06:15:49PM +0200, Luca Berra wrote:
> On Tue, Jun 18, 2002 at 08:45:45AM -0600, Monty Charlton wrote:
> > Hello all,
> >=20
> > I've got a helluva problem and I'm hoping someone here can possibly=
 help=20
> > out.
> >=20
> > I've got raid5 (sdb1,sbc1,sdd1) on a partition, and one of the driv=
es=20
> > (sdd1) went bad.  So I (stupidly) hit the reset button on the compu=
ter,=20
> > but now the partition won't mount.  Raid complains that one drive i=
s bad=20
> > (which it is), and that the other is out of sync.  See part of dmes=
g=20
> > below...
> >=20
> > Am I hosed?  Can I fake out raid by commenting out some of the code=
 that=20
> > tries to determine whether or not the drive is fresh?
> edit /etc/raidtab
> mark the drive you know as bad as
> failed-disk instead of raid-disk
> run mkraid --force on the array
> read the message you get and do as instructed.

Yes, that is exactly the way to do it.

If you mark the right disk as failed, everything will succeed and you
will not lose your data even though mkraid claims that you will.

If you, however, mark the wrong disk as failed, or forget to mark a
disk as failed, no amount of magic is going to bring those data back.

If it is really important data, it might be advisable to do a raw copy
of the individual partitions to some other machine - just in case. But
again, if you do it right, there's no problem  ;)

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
