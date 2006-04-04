From: Al Boldi <a1426z@gawab.com>
Subject: Re: Help needed - RAID5 recovery from Power-fail
Date: Tue, 4 Apr 2006 16:47:17 +0300
Message-ID: <200604041647.17153.a1426z@gawab.com>
References: <4431B2B3.9080700@nigelterry.net> <17457.46503.897583.343329@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17457.46503.897583.343329@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 2 devices in a raid5??  Doesn't seem a lot of point it being raid5
> rather than raid1.

Wouldn't a 2-dev raid5 imply a striped block mirror (i.e faster) rather than 
a raid1 duplicate block mirror (i.e. slower) ?

Thanks!

--
Al

