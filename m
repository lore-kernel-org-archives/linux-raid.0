From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Best option for SSD caching on a md raid array?
Date: Sun, 07 Feb 2016 22:14:08 -0700
Message-ID: <1670804.QnHtKWfib8@nell>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm planning on setting up a dual raid5 array for hosting vm's off LVM, I would 
like to add an ssd cache to help with typical server system loads, and some 
mixed read/write loads for game servers.

I'm wondering what the "best" route for me to go is. There's a few options 
that I know of, like flashcache, dm-cache, and bcache. The question is which of 
those is better suited to my use case?

Also wondering which ones people here use, and what they use it for.

Thanks!

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
