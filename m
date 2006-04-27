From: "Matt Harding" <Matt.Harding@pt.com>
Subject: RE: Infinite fail-retry loop on degraded RAID1 array
Date: Thu, 27 Apr 2006 15:55:50 -0700
Message-ID: <AE5398F6F2923E429D8870BFDE090196025BC1B7@sloexchange01.corp.pt.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> The only particularly "unusual" thing I can see in your configuration
> is 2.6.12, which is nearly a year old :-)

Well, what can I say; the project has taken a little longer than
originally planned...

> The code for handling read errors during resync was written in
> December, so I suspect you'll have a lot better luck with
> 2.6.16.latest.

Thanks!  I saw a post discussing a similar problem dated 2004, so I
assumed (incorrectly) that the fix had been around before 2.6.12.

Best regards,
~Matt Harding~

