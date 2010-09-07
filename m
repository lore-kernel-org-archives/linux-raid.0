From: Aryeh Gregor <Simetrical+list@gmail.com>
Subject: Re: 3-way mirrors
Date: Tue, 7 Sep 2010 14:31:18 -0400
Message-ID: <AANLkTikUt3wrpqxOX+j+3-KRKLhk4YGLvCrKxo3MAeRM@mail.gmail.com>
References: <20100907141904.3696.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100907141904.3696.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 7, 2010 at 10:19 AM, George Spelvin <linux@horizon.com> wro=
te:
> Anyway, one nice property of a 2-drive redundancy (3+-way mirror or
> RAID-6) is error detection: in case of a mismatch, it's possible to
> finger the offending drive.
>
> My understanding of the current code is that it just copies one mirro=
r
> (the first readable?) to the others. =C2=A0Does someone have a patch =
to vote
> on the data? =C2=A0If not, can someone point me at the relevant bit o=
f code
> and orient me enough that I can create it?

This might be useful reading:

http://neil.brown.name/blog/20100211050355
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
