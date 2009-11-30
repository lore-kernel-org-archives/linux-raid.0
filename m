From: Farkas Levente <lfarkas@lfarkas.org>
Subject: /etc/cron.weekly/99-raid-check
Date: Mon, 30 Nov 2009 14:08:56 +0100
Message-ID: <4B13C3E8.4090106@lfarkas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: CentOS mailing list <centos@centos.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,
it's been a few weeks since rhel/centos 5.4 released and there were many
discussion about this new "feature" the weekly raid partition check.
we've got a lot's of server with raid1 system and i already try to
configure them not to send these messages, but i'm not able ie. i
already add to the SKIP_DEVS all of my swap partitions (since i read it
on linux-kernel list that there can be mismatch_cnt even though i still
not understand why?). but even the data partitions (ie. all of my
servers all raid1 partitions) produce this error (ie. ther mismatch_cnt
is never 0 at the weekend). and this cause all of my raid1 partitions
are rebuild during the weekend. and i don't like it:-(
so my questions:
- is it a real bug in the raid1 system?
- is it a real bug in my disk which runs raid (not really believe since
it's dozens of servers)?
- the /etc/cron.weekly/99-raid-check is wrong in rhel/centos-5.4?
or what's the problem?
can someone enlighten me?
thanks in advance.
regards.

-- 
  Levente                               "Si vis pacem para bellum!"
