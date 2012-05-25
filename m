From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Re: Hi! Is "container" more efficient in terms of I/O op. numbers ...
Date: Fri, 25 May 2012 10:41:42 +0800
Message-ID: <CA+sTkh7mL8wqNqO_ejHotWpQSdr8zGOpP4hfzPEXqVTYGPFivg@mail.gmail.com>
References: <CA+sTkh55N8YKL5R-a70U9jYrj17hAdLbSoKPy-Xuz2-2S5_P0g@mail.gmail.com>
 <20120525101424.3cb40eb2@notabene.brown> <CA+sTkh68eo6by40uPYm7r+xVLLFRKvwSZYJji8x75cqW7JjJ9w@mail.gmail.com>
 <20120525122352.07d186c2@notabene.brown>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120525122352.07d186c2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25 May 2012 10:23, NeilBrown <neilb@suse.de> wrote:
[...]
> bitmap metadata certainly can be updated often, but there is no conta=
iner
> format currently supported which makes use of write-intent bitmaps, s=
o
> thinking about containers for bitmaps is not relevant.

   Well, can it be adopted by allocation sub-array for WIB then, for e.=
 g.?

> If it were, it would make sense to keep the bitmap close to the data =
that it
> described, so having a container arrangement would not be better than
> individual arrays. =C2=A0It maybe be worse depending on the particula=
r details.

   Yep, with some kind of updates merging it could be faster, I guess.

   BTW, as it seems the most optimal location of WIB is in the middle
of corresponding datum -- thus
seeks length are always less or equal (datum length 1/2). Have you
considered this layout? :-)

> Does that make sense?

   I hope so. :)

--=20
End of message. Next message?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
