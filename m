From: "pg" <pg@newhonest.com>
Subject: convert raid0 to raid 1
Date: Tue, 26 Aug 2003 16:19:19 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002b01c36baa$bfc0c5c0$2101a8c0@newhonest.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have just set up a new server with the following configuration :
sda1  & sdb1 as md0 (raid 1) for /boot
sda2  & sdb 2 as md1 (raid 1) for /

unfortunately, a few days after the server is running, I found I made a
mistake. I setup the md1 as raid0 rather than raid1. So I have to convert
the md1 from the mistakened raid 0 back to raid 1. What should I do to fix
my problem??

I'm using redhat-9 with two xeons.
Boot manager : grub.

-Jason

