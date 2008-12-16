From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Awful Raid10,f2 performance
Date: Tue, 16 Dec 2008 23:01:47 +0100
Message-ID: <20081216220147.GA22148@rap.rap.dk>
References: <48440953.3040004@wpkg.org> <cccedfc60806020809t73794ce6w539c6b0d247a264f@mail.gmail.com> <cccedfc60812150533p31974f4bye490958dbc974212@mail.gmail.com> <18758.52823.375213.963854@notabene.brown> <cccedfc60812151847u6e69a44jc50b3f58da5b9171@mail.gmail.com> <20081216040349.GA15389@rap.rap.dk> <cccedfc60812152028g5d5e88c5r23d5d8f873fe8538@mail.gmail.com> <20081216101020.GA17410@rap.rap.dk> <cccedfc60812160726w3892c241i6fca4b498a9c959d@mail.gmail.com> <cccedfc60812160753w609e50efga655d34a9e0b4bce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60812160753w609e50efga655d34a9e0b4bce@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Neil Brown <neilb@suse.de>, Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Dec 16, 2008 at 09:53:39AM -0600, Jon Nelson wrote:
> On Tue, Dec 16, 2008 at 9:26 AM, Jon Nelson
> <jnelson-linux-raid@jamponi.net> wrote:
> > On Tue, Dec 16, 2008 at 4:10 AM, Keld J=F8rn Simonsen <keld@dkuug.d=
k> wrote:
> >> On Mon, Dec 15, 2008 at 10:28:30PM -0600, Jon Nelson wrote:
> >>> On Mon, Dec 15, 2008 at 10:03 PM, Keld J=F8rn Simonsen <keld@dkuu=
g.dk> wrote:
> >>>
> >>> > there was a pach to speed up raid10,f2 check in a recent kernel=
,
> >>> > something like 2.6.27. It did improve thruput from something
> >>> > like 40 % to about 90 %. What kernel are you using?
> >>>
> >>> 2.6.25.18-0.2-default
> >>
> >> I believe the patch arrived in a later kernel. If you can try it o=
ut
> >> with a vanilla kernel and report, I think it would be quite intere=
sting.
> >
> > I'm pretty sure I did try it out and did have an improvement.
> > However, thanks to the power of the openSUSE build service, I am go=
ing
> > to build a kernel just now, if I can.
>=20
> Scratch that. I decided to just do this at home. The suse kernel
> 2.6.25.18-0.2 appears to have this patch already. Thus, I've been
> running with this patch.

OK, well, then the patch did not apply to check, but only to resync.
One could write up a similar patch for check as what was done for
resync. The idea of the previous patch was to read quite much data in a
striped way, say 10 - 20 MB at a time.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
