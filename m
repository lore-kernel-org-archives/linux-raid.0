From: Jean-Baptiste Thomas <cau2jeaf1honoq@laposte.net>
Subject: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 08:37:59 +0200 (CEST)
Message-ID: <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net>
References: <1610581828.22506051.1430116628556.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1610581828.22506051.1430116628556.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm looking for a way to get MD to operate in a mode in which
reading a sector from a RAID-1 device would not succeed until it
got matching data from at least two components.

Recent experience[1] suggests that a transient problem in one
disk can completely hose a four way RAID-1 array, which is
otherwise supposed to still be fine after a triple total
failure. I'm hoping that a paranoid mode would have prevented
that.

If there is such a thing, PLEASE tell me. If not, please tell me 
so I don't waste any more time looking for it.

[1] "Massive RAID-1 desync"
http://www.spinics.net/lists/raid/msg48681.html
http://marc.info/?l=linux-raid&m=143003812706563&w=2
