From: Bruce Miller <subscribe@brmiller.ca>
Subject: Sensible settings for a three (or four) device RAID 10 f2 array using recent SATA II disks
Date: Wed, 9 Dec 2009 19:59:45 -0800 (PST)
Message-ID: <990246.33965.qm@web88304.mail.re4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I would welcome comments on sensible chunk and stripe settings to use for my first venture into RAID which I will be setting up over the upcoming holiday quiet period. The array will be setup as a Linux MD RAID 10 f2. It will have either three 500GB SATA II 7200rpm physical drives or possibly 2 x 500GB drives plus 1 x 1TB SATA II 10Krpm drive divided into two 500GB partitions for a total of four devices.

I have decided on this setup from almost two years of lurking on this list. I will be working my way studiously through 50 pages of the wiki overview on the linuxfoundation.org website before I begin any actual setup. Even so, I would welcome a message off-list from a more expert user ready to field a question from a first-timer.

Personal background: I am recently retired. I have never been an IT professional; on the other hand, as an amateur, I have been happily breaking alpha and beta software for the last 27 years --- that is, from long before GUIs migrated from PARC into the commercial world. I pride myself on being a quick study. The primary goals of setting up a RAID array are education and performance. BTW, I do not confuse RAID with backup and have religion on the importance of multilayered onsite and offsite backup. My strategy has just been tested less than a week ago by the sudden (and apparently irretrievable) failure of the data drive on my primary workstation. It is this workstation which I will rebuild over Christmas with a RAID array; the fallback old desktop computer is just not as pleasant to work
  on <grin>.

 
--
Bruce Miller, Ottawa, Ontario, Canada
bruce@brmiller.ca; (613) 745-1151

A conservative is a man with two perfectly good legs who, however, has never learned to walk forward.
- Franklin D. Roosevelt

