From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Proposal for metadata version 2.x :)
Date: Sun, 17 Jun 2012 18:12:14 +0800
Message-ID: <CA+sTkh6ATWGjByZuKvRCkcwTW1cJw73mNNK92LW5WNfpi2eXKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

   Hi! If I understand correctly, one cannot safely switch between 1.x
metdata layouts since data offsets would be different, right?

   Why not to overcome this limitation by holding all three metadata
zones reserved to prevent RAID data allocation inside them? It doesn't
seem to be significant waste of disk space, but would be more flexible
indeed.

--
