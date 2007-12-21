From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: raid10: unfair disk load?
Date: Fri, 21 Dec 2007 17:49:02 +0100
Message-ID: <20071221174902.6fc02c4e@absurd>
References: <476BA4FD.6080401@msgid.tls.msk.ru>
	<476BA942.40406@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476BA942.40406@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Tokarev said:     (by the date of Fri, 21 Dec 2007 14:53:38 +0300)

> > I just noticed that with Linux software RAID10, disk
> > usage isn't equal at all, that is, most reads are
> > done from the first part of mirror(s) only.

what's your kernel version? I recall that recently there have been
some works regarding load balancing.

-- 
Janek Kozicki                                                         |
