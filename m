From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: raidreconf: Successful RAID5 Reconstruction (re-size)
Date: Wed, 26 Jun 2002 20:44:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020626184440.GD4914@unthought.net>
References: <20020626180640.GC4914@unthought.net> <NDBBIAKEEKGGEIKCBKNAIEOKDAAA.kc130iseo@coastalnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <NDBBIAKEEKGGEIKCBKNAIEOKDAAA.kc130iseo@coastalnet.com>
To: cwebster@ec.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 26, 2002 at 02:40:07PM -0600, Cal Webster wrote:
>=20
=2E..
> > It is also possible that you have hardware errors, bad cabling, bad
> > disk, etc.  Anything suspicious in dmesg ?
>=20
> I doubt that there were any kind of hardware errors. I double-checked
> everything and scanned the logs after installing the new drives. Ther=
e were
> no problems using the array in its original configuration after insta=
lling
> the new drives, but before reconfiguring. I've included RAID-related =
entries
> from "dmesg" at the bottom of this message. This is since the last re=
boot
> after "mkraid".

Yes, I suspect it's most likely a raidreconf screwup.

Sorry about that.

>=20
> > It is really important to run fsck -f on arrays after running raidr=
econf
> > and before re-sizing the filesystem.  For this reason - tracking of
> > when/where errors occurred.  Of course, it is a little late for you=
 to
> > be told this now - sorry.  I should add this note to the raidreconf
> > output after successful reconfiguration.
>=20
> Yes, that might have been helpful information. I had a backup plan an=
yway.
> I'll take this extra step next time, but I don't envision it happenin=
g
> anytime soon.

That's the problem with raidreconf.  You need it once a year, and you
can't use it unless you can actually trust it 100% (which you can't).

I want to move to theory - everything works in theory...

>=20
> There is likely some information in /var/log/messages that may be use=
ful to
> you. Would you like me to attach a "gzipped" copy of it to a reply? I=
'm
> sorry, but I don't have time to pick through it right now to extract =
the
> RAID info.

No that's ok.

I'll see if I can reproduce the spare-disk "feature" tonight.

>=20
> Thanks! :-)

You're welcome   ;)

(If anyone else need their arrays screwed up, you know where to get the
 tools !   ;)

On the more serious side, thanks a lot for your feedback !  And sorry
about the array.   I'm glad you knew that backups aren't just for
sissies.

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
