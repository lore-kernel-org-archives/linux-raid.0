From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: LVM over RAID, or plain disks? A:"Yes" = best of both worlds?
Date: Mon, 29 Nov 2010 16:29:16 +0100
Message-ID: <20101129152916.GB13310@www2.open-std.org>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com> <2D.98.07087.690A2FC4@cdptpa-omtalb.mail.rr.com> <AANLkTinUmZoqSWNZ7NK+tg5DTpc5JFbbPPZV6YONq+ox@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinUmZoqSWNZ7NK+tg5DTpc5JFbbPPZV6YONq+ox@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On Mon, Nov 29, 2010 at 06:01:11PM +0700, hansbkk@gmail.com wrote:
> On Mon, Nov 29, 2010 at 1:34 AM, Leslie Rhorer <lrhorer@satx.rr.com> =
wrote:
> >> - I am not at this point overly concerned about performance issues=
 -
> >> reliability/redundancy and ease of recovery are my main priorities=
=2E
> >
> > =A0 =A0 =A0 =A0In that case, I'm not sure about your desire for the=
 additional
> > complexity. =A0Someone else suggested RAID6, which from an operatio=
nal
> > standpoint is much simpler. =A0The main reason, it seems to me, for=
 the more
> > complex topologies would be enhancing perfromance.
>=20
> I can see how RAID6 is simpler than RAID10, but compared to RAID1?

Hmm, does not compute by me. RAID1 and RAID10 are the same in complexit=
y,
RAID10 is just a modern RAID1, and should actually have been called
RAID1.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
