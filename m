From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Western Digital RE3: Raid Failure
Date: Thu, 3 Sep 2009 13:06:54 +0200
Message-ID: <20090903110654.GC7812@boogie.lpds.sztaki.hu>
References: <b9f8dfb10908270243u1213576cs7c5cbc743d637c1c@mail.gmail.com>
 <4A9C3969.8000304@gmail.com>
 <b9f8dfb10909030214u2144b4fag417997ff9a38f315@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b9f8dfb10909030214u2144b4fag417997ff9a38f315@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "MOgWai46[Saurceful of Secrets]" <street41@gmail.com>
Cc: Zdenek Kaspar <zkaspar82@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 03, 2009 at 11:14:45AM +0200, MOgWai46[Saurceful of Secrets] wrote:

> This is the output of smartctl -a /dev/sdc: http://nopaste.com/p/aXwmnSEphb

  5 Reallocated_Sector_Ct   0x0033   197   197   140    Pre-fail  Always       -       24
[...]
196 Reallocated_Event_Count 0x0032   197   197   000    Old_age   Always       -       3

IMHO it's time to replace the drive. I think it also shows that TLER is
working just as expected: timing out when the recovery would have taken
too long.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
