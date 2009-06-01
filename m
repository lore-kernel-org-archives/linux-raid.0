From: raz ben yehuda <raziebe@gmail.com>
Subject: chunk size fix -- found a bug
Date: Mon, 01 Jun 2009 19:34:01 +0300
Message-ID: <1243874041.9384.2.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Hello
I my last chunk size fix there is a bug. I did not align the zones sizes
to a chunk size. 
Currently i have it fixed locally, but because I am not ready with the
reshape patches I rather tell u instead of sending a fix.
raz


