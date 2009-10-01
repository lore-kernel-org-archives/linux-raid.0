From: Raz <raziebe@gmail.com>
Subject: raid0 failures
Date: Thu, 1 Oct 2009 16:31:22 +0200
Message-ID: <5d96567b0910010731t513a84a5m1f85e715a69efab6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Hello
I have noticed that raid0 cannot tell if an IO to a had disk failed or
not. This is a problem in some cases because i need the raid to stop.
I am thinking of fixing it. what is the best approach if any you
believe is possible ?
thank you
raz
