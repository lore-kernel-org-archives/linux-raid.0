From: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Subject: Re: RAID5/6 slow due to a member device -- how to diagnose?
Date: Thu, 03 Mar 2016 15:35:21 +0100
Message-ID: <4472129.pebMKxQj7W@matkor-toshiba>
References: <20160303193026.7d08e64b@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160303193026.7d08e64b@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 03 March 2016 19:30:26 Roman Mamedov wrote:
> But is that broken down somewhere to show which particular block devi=
ce is
> being the most 'waited for'?

iostat  ?

r_await w_await  svctm  %util  columns?

Regards,

--=20
Mateusz Korniak
"(...) mam brata - powa=C5=BCny, domator, liczykrupa, hipokryta, pobo=C5=
=BCni=C5=9B,
 	kr=C3=B3tko m=C3=B3wi=C4=85c - podpora spo=C5=82ecze=C5=84stwa."
				Nikos Kazantzakis - "Grek Zorba"

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
