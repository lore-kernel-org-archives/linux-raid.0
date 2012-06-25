From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: "mdadm: Raid level 5 not permitted with --build" -- why is that?
Date: Mon, 25 Jun 2012 19:33:23 +0800
Message-ID: <CA+sTkh7cYEmrujcRkvisFM1EksQBJ2kMKBfkd3RyDwr2-bvGpw@mail.gmail.com>
References: <CA+sTkh70JopNMbh0VQXDCq2MY+GHq0hQEPyKT1e9mRXxfk_2xw@mail.gmail.com>
 <20120625165242.117881e1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625165242.117881e1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25 June 2012 14:52, NeilBrown <neilb@suse.de> wrote:
> On Fri, 22 Jun 2012 11:07:33 +0800 Igor M Podlesny <for.poige+lsr@gma=
il.com>
> wrote:
>
>> =C2=A0 =C2=A0subj. Hi :)
>
> Please try to construct coherent email message. =C2=A0If you want peo=
ple to read
> what you write, make it easy for them.

   And what is so uneasy in such a little quoting sentence?, I shall as=
k.

   Those, who know where does the quote come from, are the target
group, those, who doesn't =E2=80=94 aren't.

   What's the problem?

> Because!
>
> With nowhere to record device failure, you don't have any safety.

   Well, suppose you don't need one =E2=80=94 due to short-term period =
of such
an array existence which in its turn was predicated by real array
failure, say, damaging superblocks (if it reminds you something).
mdadm -C would create one, but you may not know which '-e' to specify.
That's the reasoning beneath to have -B which wouldn't overwrite any
data on disks at all so ideally fitting as a probe tool.

> Feel free to send a patch.

   =E2=80=94 "Feel free" to spend time digging into an area which isn't=
 what
you get paid for? At least what exactly should be patched this time,
will you kindly tell us?
>
> NeilBrown

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
