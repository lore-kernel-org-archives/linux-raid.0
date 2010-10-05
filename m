From: Pavel Shevaev <pacha.shevaev@gmail.com>
Subject: Restoring data from linear raid
Date: Tue, 5 Oct 2010 12:25:58 +0400
Message-ID: <AANLkTik6gET5PXskntGGNC4xfrga8UHxU7pcJXwArYgS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks!

Two years ago I bought a WDC MyBookWorld II NAS which is using Linux
software raid internally. I thought it used raid1 but it turned out
that in my case it used linear mode. Oh, stupid me, I didn't bother to
check. One of the drives is dead now(it works very unstable, may work
for a while and then just go down for no reason).

I really want to restore _anything_ from the linear raid partition of
the working drive, is it possible at all?

P.S. I googled around and only found the thread with the similar topic
but, I believe, the original author was talking about raid0 actually
and not linear mode.

-- 
Best regards, Pavel
