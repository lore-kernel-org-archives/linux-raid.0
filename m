From: Alex Tomas <bzzz@tmi.comex.ru>
Subject: Re: linear writes to raid5
Date: Wed, 12 Apr 2006 00:55:22 +0400
Message-ID: <m33bgjsuh1.fsf@bzzz.home.net>
References: <Pine.LNX.4.44.0604091600230.22779-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0604091600230.22779-100000@coffee.psychology.mcmaster.ca> (Mark
 Hahn's message of "Sun, 9 Apr 2006 16:24:07 -0400 (EDT)")
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Alex Tomas <alex@clusterfs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> Mark Hahn (MH) writes:

 MH> don't you mean _3_ chunk-sized writes?  if so, are you actually
 MH> asking about the case when you issue an aligned two-stripe write?
 MH> (which might get broken into 6 64K writes, not sure, rather than 
 MH> three 2-chunk writes...)

actually, yes. I'm talking about 3 requests: 2 of data and one of parity.
