From: Bruce Miller <subscribe@brmiller.ca>
Subject: How many disks per SATA-II bus?
Date: Tue, 29 Jan 2008 13:25:35 -0500 (EST)
Message-ID: <214675.77163.qm@web88308.mail.re4.yahoo.com>
Reply-To: subscribe@brmiller.ca
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The beginning of Section 4 of the Linux Sotfware-RAID-HOWTO
states emphatically that "you should only have one device per
IDE bus. Running disks as master/slave is horrible for
performance. IDE is really bad at accessing more that one drive
per bus".

Do the same cautions apply to building a RAID array using
SATA-II disks?

--
Bruce Miller
Ottawa ON, Canada
bruce@brmiller.ca
(613) 745-1151
This message is from a webmail login and not from my regular mail system. It does not have my customary digital signature.
