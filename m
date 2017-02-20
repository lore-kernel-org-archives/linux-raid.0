From: "Christian Samsel" <csamsel@gmxpro.de>
Subject: Device size for linux raid5 journal?
Date: Mon, 20 Feb 2017 17:50:09 +0100
Message-ID: <trinity-e6976ea9-ab41-4a2a-85ce-50b77ded8f35-1487609409044@3capp-gmx-bs16>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello raid team,
First of all, thanks for your work.
So i recently read about Linux raid5/raid6 write-cache and journaling and thought about
giving it a try. I'm mainly interested in the additional safety provided by the journal but might
want be future proof to use the write cache as well.
I read how to create an array using a journal but i havent found the slightest indication of how
large the respective device/partition should be. I went through the lwn article [1], the slides [2] of the
respective engineers at facebook and a few commit messages.

So my question is, let's assume i have a 6TB raid5 array (3x3TB), what would a good journal device size be?
I'd probably went with 4GB, as this is kinda the upper bound of what hardware raid controller offer. 

Christian

[1] https://lwn.net/Articles/665299/
[2] http://events.linuxfoundation.org/sites/events/files/slides/2016_vault_write_journal_cache_v2.pdf
