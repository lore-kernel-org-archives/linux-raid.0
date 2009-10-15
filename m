From: Drew <drew.kay@gmail.com>
Subject: Re: [mdadm PATCH] Introduce a commandline option for setting
	RebuildNN increment size
Date: Thu, 15 Oct 2009 09:00:38 -0700
Message-ID: <c268e4660910150900uc051deeja2da04f357dc8ed9@mail.gmail.com>
References: <4AD730CC.2010701@matfyz.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD730CC.2010701@matfyz.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Behan <rain@matfyz.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As a end user I like the idea. Two questions around the choice of
increments, though.

If we're going to allow values up 99, why not include 100? To my mind,
reporting 0% -> 99% -> 100% offers about the same value as reporting
0% -> 100%.

Also, It seems to me that increments beyond 50 aren't really that
useful. For example, reporting 0% -> 75% -> 100% seems a bit odd to
me, even for extremely fast rebuilds. Units up to 50 (0%, 50%, 100%)
make more sense.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
