From: Neil Brown <neilb@suse.de>
Subject: Re: reshape from raid5 to raid6 failed -- and backup file is gone?
Date: Fri, 23 Apr 2010 08:09:38 +1000
Message-ID: <20100423080938.5ef90287@notabene.brown>
References: <n2j657cbef51004221132uf2d7f5cds1268f848fee1489e@mail.gmail.com>
	<q2u657cbef51004221446l41381e31hf26f96072b04983e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <q2u657cbef51004221446l41381e31hf26f96072b04983e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rich Rauenzahn <rrauenza@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Apr 2010 14:46:32 -0700
Rich Rauenzahn <rrauenza@gmail.com> wrote:

> On Thu, Apr 22, 2010 at 11:32 AM, Rich Rauenzahn <rrauenza@gmail.com>=
 wrote:
> > The system froze sometime in the middle of the night, and oddly... =
the
> > --backup-file I specified last night is missing. =C2=A0Is there any=
 reason
> > that mdadm would unlink it for a short span of time during the
> > reshape?
>=20
> I'm at the point now where I'm just looking for triage advice so I ca=
n
> work on it tonight. Most of the contents were backed up offsite, but =
a
> little bit out of date.  Nothing critical, but inconvenient, like
> recovery images for relative's systems.
>=20
> Do I kill it and start over, or is there any hope of recovering from
> the reshape?


It is very odd that the backup file disappeared.  What is
   /.MEDIA/tmp
?? Not a tmpfs filesystem I hope...

You could hack mdadm to assemble the array even without a backup file.
Get 'Grow_restart' to always return 0.

Then most of your data should be assessible, but the could be a section=
 in
the middle which is currupt.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
