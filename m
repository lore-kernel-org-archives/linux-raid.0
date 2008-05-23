From: "Henry, Andrew" <andrew.henry@logica.com>
Subject: ESATA discs spindown.  Can mdadm handle this?
Date: Fri, 23 May 2008 11:44:12 +0200
Message-ID: <3ECBDC05781B3D48ABD520A01ABF2F9B12C56CBEA7@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Is it an issue for mdadm if my discs spindown?  I have seen that I can use sdparm -C start /dev/sda and schedule this with cron to keep them alive, but is there a better way?

If there is a problem with spindown, then what is the issue?  Why can't mdadm manage this?

 --andrew
