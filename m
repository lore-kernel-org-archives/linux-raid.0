From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: RE: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 10:33:27 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601191031400.20928-100000@coffee.psychology.mcmaster.ca>
References: <17358.52476.290687.858954@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17358.52476.290687.858954@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

>  Use either for raid0 (I don't think dm has particular advantages
>      for md or md over dm).

I measured this a few months ago, and was surprised to find that 
DM raid0 was very noticably slower than MD raid0.  same machine,
same disks/controller/kernel/settings/stripe-size.  I didn't try
to find out why, since I usually need redundancy...

regards, mark hahn.

