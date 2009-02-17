From: Redeeman <redeeman@metanurb.dk>
Subject: RE: problem in grow of raid5 3 -> 4 disks
Date: Tue, 17 Feb 2009 22:12:58 +0100
Message-ID: <1234905178.18827.25.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(sorry its not properly threaded, but message didnt show up via
mailinglist yet)

To add some information, i think the culprit is that he forgot support
for large block devices in kernel (its 32bit x86)..

What is the recommendation based on this? enable support, and reboot?


Thanks again.

