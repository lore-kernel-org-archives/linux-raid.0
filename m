From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: corruption on disk
Date: Sun, 23 Jan 2005 22:46:02 +0100
Message-ID: <qhidc2-a8r.ln1@news.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just a followup ...

Neil said he has never seen disks corrupt spontaneously. I'm just making
the rounds of checking the daily md5sums on one group of machines with
a view to estimating the corruption rates. Here's one of the typical
(one bit) corruptions:

  doc013:/usr/oboe/ptb% cmp --verbose /tmp/cardmgr /sbin/cardmgr 
    1641  22  52

/tmp has the correct version, copied from elsewhere.  I haven't checked
yet to see if it's a memory error or a disk error. I'll reboot the
whole set later. But this machine has been up only 2 days so it's
unlikely to have accumulated errors, and cardmgr will not have been
used apart from being md5summed.

There are 30 machines in this set. I may have more stats when I have
finished.

Peter




