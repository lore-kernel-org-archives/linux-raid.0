From: "bo" <bo@sosnetwork.net>
Subject: resync patch & Neil's recent patches
Date: Wed, 26 Jun 2002 15:14:55 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <009b01c21d5e$e68c7050$5701a8c0@bomoon>
References: <1025113529.1793.8.camel@jason.storix.com><15642.421.825234.16918@notabene.cse.unsw.edu.au><1025114738.1794.19.camel@jason.storix.com> <15642.1309.651737.496391@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil & Raiders,

I am using Debian 2.4.5 linux(for ARM ). The "resync" speed is about
26M/sec.
I have 8*120G HDDs so it takes about 24 hours.

I saw some bug fixes and improvement on this topic from
 http://marc.theaimsgroup.com/?l=linux-kernel&m=100876771508736&w=2

Q1: Can I apply this patch to my 2.4.5 linux?
Q2: Which linux2.4.x has this fix?

Q3: Neil released 22 + 3 patches a couple of weeks ago.
       Can I apply these pathes to 2.4.5?

       Which linux 2.4.x will include these fixes?

Q3: The default MAX resync speed is 200M/sec. I am getting about
       10 % of this default speed. Could anyone get it? Could I get
       this average speed when I apply these patches?

Thanks,

Bo



