From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Mon, 04 Feb 2008 10:45:19 -0600
Message-ID: <47A7411F.2040702@sandeen.net>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net> <47A72FBC.9090701@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A72FBC.9090701@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> So if I understand you correctly, you're stating that current the most 
> reliable fs in its default configuration, in terms of protection against 
> power-loss scenarios, is XFS?

I wouldn't go that far without some real-world poweroff testing, because
various fs's are probably more or less tolerant of a write-cache
evaporation.  I suppose it'd depend on the size of the write cache as well.

-Eric
