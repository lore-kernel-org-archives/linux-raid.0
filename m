From: "Dragon" <Sunghost@gmx.de>
Subject: Possible to rescue SW Raid5 with 2 missing Disks
Date: Wed, 20 Feb 2013 09:54:54 +0100
Message-ID: <20130220085454.161010@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
ok i hoped the situation will turn arround and we can rescue the system. As i wrote at the first post Phil and i testet all order and checked with fsck. as an result of that, look at the first post, the most confidence would the last test with:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c,f,e}4 missing

am i right?
