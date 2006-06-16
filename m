From: Tim <irule@irule.net>
Subject: Raid5 reshape
Date: Thu, 15 Jun 2006 23:34:21 -0700
Message-ID: <449250ED.7090302@irule.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I'm sorry if this is a silly question, but I've been digging around for
a few days now and have not found a clear answer, so I'm tossing it out
to those who know it best.

I see that as of a few rc's ago, 2.6.17 has had the capability of adding
additional drives to an active raid 5 array (w/ the proper ver of mdadm,
of course). I cannot, however, for the life of me find out exactly how
one goes about doing it! I would love if someone could give a
step-by-step on what needs to be changed in, say, mdadm.conf (if
anything), and what args you need to throw at mdadm to start the reshape
process.

As a point of reference, here's my current mdadm.conf:


DEVICE /dev/sda1
DEVICE /dev/sdb1
DEVICE /dev/sdc1
ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1 level=5 num-devices=3


I will be adding the devices /dev/sde1 and /dev/sdf1 (when I can find
out how :)

Thanks in advance,
-Tim

