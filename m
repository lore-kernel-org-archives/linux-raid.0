From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Raid5 Read stats for parity cal...
Date: Wed, 16 Sep 2009 17:13:30 -0700
Message-ID: <f5d1f90a0909161713s2f31e3b4t34a4ee285b83ef8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello:

I understand that parity calculations are not done as part of Raid5
read operation in normal running conditions.

However, it would be done during disk failure or when a sector is bad.
Is there a way (any stats) available to see if parity cal are done
when sector is bad (since this is not as obvious as a disk fail...)

Thanks!
