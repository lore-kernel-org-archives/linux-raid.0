From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: cluster raid
Date: Mon, 28 Apr 2003 16:16:45 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030428141644.GA18065@marowsky-bree.de>
References: <D397A7FACCC45A44A0A207FD892961EA03B2DA3C@mail.intra.cet.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D397A7FACCC45A44A0A207FD892961EA03B2DA3C@mail.intra.cet.pt>
To: Miguel Biscaia <miguel-b-pias@ptinovacao.pt>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2003-04-28T15:06:03,
   Miguel Biscaia <miguel-b-pias@ptinovacao.pt> said:

> Hello,
> At my company we are implementing a shared disk database arquitecture=
 for
> telecom call processing, based on Linux. I would like to use MD devic=
es,
> although I?m not aware if the MD devices can be configured and starte=
d in
> cluster environments. Is it possible? In which kernel version?

They cannot be used in a shared configuration; it will only work if onl=
y
one node has activated any given md device at any time.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
