From: "pg" <pg@newhonest.com>
Subject: raid0 to raid1
Date: Wed, 3 Sep 2003 13:34:40 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <005f01c371dd$12f0fc00$2101a8c0@newhonest.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Excuse me for asking the question again, because my last question has not
been answered.

I have two scsi hd of same geometry : 36G
I want to have
sda1 sdb1 map to /boot by raid1
sda2 sdb2 map to /     by raid1

Unfortunately, I wrongly formated sda2+sdb2 to raid0, and the error was
discovered a few weeks after the server has been put into production.

So my problem is how can I use minimum time to convert the raid0 back to
radi1 safely?



-Jason

ps The usage of sda2+sdb2 is less than 10G at the present moment

