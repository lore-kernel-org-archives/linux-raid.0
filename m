From: Michael Tokarev <mjt@tls.msk.ru>
Subject: mdadm: Raid level 10 not permitted with --build ?
Date: Fri, 24 Apr 2009 00:05:19 +0400
Message-ID: <49F0C9FF.9020009@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The question is: why can't one build a "legacy", aka
metadata-less, raid10 array?

I've a particular task here, to have an array which is
NOT persistent across reboots, but should only be valid
during system runtime.  Example of such usage is swap
space - we need to continue running even in case of
some drives failed, but we don't need to preserve
the content of swap space across reboots.  Here I've
an application that collects large amounts of data
which is only relevant during application runtime,
the data has no meaning at all after restart -- pretty
similar to the swap usage.

But mdadm does not let me to build such an array.
Is there any reason why?

Basically I want to avoid resync in case of unclean
shutdown and don't want to resort to using bitmaps.
Re-creating the whole thing on startup with
--assume-clean works just fine, if only not this
limitation.

Not that this is very important and generally useful
question but still... ;)

Thanks!

/mjt
