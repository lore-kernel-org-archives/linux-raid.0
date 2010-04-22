From: Rich Rauenzahn <rrauenza@gmail.com>
Subject: Re: reshape from raid5 to raid6 failed -- and backup file is gone?
Date: Thu, 22 Apr 2010 14:46:32 -0700
Message-ID: <q2u657cbef51004221446l41381e31hf26f96072b04983e@mail.gmail.com>
References: <n2j657cbef51004221132uf2d7f5cds1268f848fee1489e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <n2j657cbef51004221132uf2d7f5cds1268f848fee1489e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

On Thu, Apr 22, 2010 at 11:32 AM, Rich Rauenzahn <rrauenza@gmail.com> w=
rote:
> The system froze sometime in the middle of the night, and oddly... th=
e
> --backup-file I specified last night is missing. =A0Is there any reas=
on
> that mdadm would unlink it for a short span of time during the
> reshape?

I'm at the point now where I'm just looking for triage advice so I can
work on it tonight. Most of the contents were backed up offsite, but a
little bit out of date.  Nothing critical, but inconvenient, like
recovery images for relative's systems.

Do I kill it and start over, or is there any hope of recovering from
the reshape?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
