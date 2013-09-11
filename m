From: Martin Wilck <mwilck@arcor.de>
Subject: Implementing --detail-platform for DDF
Date: Wed, 11 Sep 2013 23:00:06 +0200
Message-ID: <5230D9D6.7030005@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,

I thought I might come up with an implementation of mdadm
--detail-platform for DDF, but I encountered a problem I'd like to discuss.

For DDF, we can't scan PCI devices like IMSM does, because we don't know
all controllers supporting DDF. Thus I considered scanning block devices
instead and looking at "foreign" vendor strings in the meta data;
possibly also filtering by device names or types. It occured to me that
it might be elegant to simply call conf_get_devs() for a list of devices
to be scanned. But if I do that, config.o and its dependencies must be
linked with mdmon, blowing up its size considerably. I figure that
that's a no-go. But I'm also reluctant to write my own DDF-specific
block device scanning code while there is conf_get_devs() already.

Perhaps I am misunderstanding the purpose of --detail-platform?
I wouldn't bother with it if YaST2/libstorage didn't call it in order to
check if a "fake RAID" platform is present.

Regards
Martin
