From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: [PATCH md ] md: allow degraded raid1 array to resync after an unclean shutdown.
Date: Sun, 27 Mar 2005 03:38:25 +0100
Message-ID: <62b0912f05032618385c6bc57f@mail.gmail.com>
References: <20050323142016.12770.patches@notabene>
	 <E1DDwaW-0003NC-5X@notabene.cse.unsw.edu.au>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <E1DDwaW-0003NC-5X@notabene.cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The following is (I think) appropriate for 2.4.30.  The bug it fixes
> can result in data corruption in a fairly unusual circumstance (having
> a 3 drive raid1 array running in degraded mode, and suffering a system
> crash).

What's unusual?  Having a 3 drive raid1 array?

It's not unusual for a system to crash after a RAID array gets sent to
degraded mode.  Happens a lot on a system I administer.  Probably
caused by a linux-si3112-ide bug which first results in read errors, then
(after md has been told to resync) results in a complete system crash...

Another topic:
Just noticed MD usage in a screenshot:
  http://linuxdevices.com/files/misc/ravehd_screenshot.png
From this article:
  http://linuxdevices.com/news/NS8217660071.html
Just in case anybody cares :-).
