From: David Rees <drees76@gmail.com>
Subject: Re: SSD & mechanical disc in RAID 1
Date: Mon, 1 Feb 2010 13:10:52 -0800
Message-ID: <72dbd3151002011310g57fa9b66j2798aa0acde199b2@mail.gmail.com>
References: <7a329d911001090953j17829cd9qca0888fbcd7b4805@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7a329d911001090953j17829cd9qca0888fbcd7b4805@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wil Reichert <wil.reichert@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 9, 2010 at 9:53 AM, Wil Reichert <wil.reichert@gmail.com> w=
rote:
> Has anyone ever tried putting an SSD and a mechanical disc in RAID 1
> using write-mostly? =A0The goal would be to extol the speed & latency
> virtues of an SSD while retaining the integrity of the traditional
> storage. =A0Would this setup even work as I expect it to?

I have such a setup using a 30GB OCZ Vertex and an old 120GB Seagate
7200.7 (IDE!).

Read performance is exactly as you'd expect - very fast as all reads
come from the SSD so it's as fast as the SSD (though I haven't
benchmarked it to verify).  At least my seat of the pants (SOTP)
measurement in comparison to other SSDs seems very similar.

Write performance is also what you'd expect, the same as an old IDE dri=
ve.

=46or a budget setup, it does what I expected it to.

I suspect that if you used write-behind with a write-intent bitmap
stored only on the SSD, you'd get some of that performance back, but
potentially lose a bit of reliability.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
