From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: RFC - new raid superblock layout for md driver
Date: Tue, 10 Dec 2002 09:17:45 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D66703158F@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

> When a raid1 array is out of sync, it doesn't mean anything to say
> which disc is out of sync.  They all are, with each other...
> Nonetheless, the per-device stateflags have an 'in-sync' bit which can
> be set or cleared as appropriate.

Not quite, esp. not in the case of interrupted sync. in that case you've got
one disk with valid data and another disk known to contain nothing usable.

Disk1		Disk2
aaaaaaaaaa	aaaaabbbbb

If the information that disk2 is currently NOT usable isn't preserved bad
things might happen on resume - I don't think a result of 

Disk1		Disk2
aaaaabbbbb	aaaaabbbbb

after resync finishes would make anyone especially happy :-)

So as soon as we get into the "resume raid sync" business, even raid1 very
defininitely needs in/out-of sync indicators.

Bye, Martin
