From: "Bo Moon" <bo@anthologysolutions.com>
Subject: raid resync
Date: Wed, 8 Oct 2003 18:36:04 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <087f01c38e05$b401bfa0$6501a8c0@bmasi>
References: <40408.194.237.142.24.1064555851.squirrel@ncircle.nullnet.fi><16243.55544.424789.503682@notabene.cse.unsw.edu.au><61251.194.237.142.24.1064557502.squirrel@ncircle.nullnet.fi><16243.57487.124068.470173@notabene.cse.unsw.edu.au><17620.194.237.142.24.1064560221.squirrel@ncircle.nullnet.fi> <16243.61083.69286.766387@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

From md.c, there must be some changes or improvement to RAID1&5 resync code,
which enabled the request based resynchronization.

Does it mean we could enable or disable this resync?
If so, how could we make it(where in the code)?

Why do we have this feature the disk will be under no integrity if we
disable this resync?

Thanks in advance,

Bo

