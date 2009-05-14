From: Sujit Karataparambil <sjt.kar@gmail.com>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over all
	strip_zones.
Date: Thu, 14 May 2009 18:24:59 +0530
Message-ID: <921ca19c0905140554i51dea6bavf7862c2ef0106dbf@mail.gmail.com>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-2-git-send-email-maan@systemlinux.org>
	 <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
	 <20090514121042.GH11504@skl-net.de>
	 <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, raziebe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi neil,

could you please tell? out of curiosity what happens when a null is ret=
urned by
find_zone.

On Thu, May 14, 2009 at 5:55 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, May 14, 2009 10:10 pm, Andre Noll wrote:
>> Yup. Do you want me to rework the patches, or should I follow up wit=
h
>> patches on top of the series?
>
> A fresh new set please. =A0And I agree with everything else you said =
in
> the email.
>
> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
-- Sujit K M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
