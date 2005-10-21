From: Peter Lauda <plauda@rx30.com>
Subject: raid'ing problems
Date: 21 Oct 2005 08:50:39 -0400
Message-ID: <1129899043.32525.4.camel@plauda5.rx30.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If anyone is listening....

I have read the howto's and all the FAQ's I can find. I am trying to do
the following and having zero success:

An installed system needs to have a second disk setup with the first as
a raid 1 set. 

I have been able to boot from a CD and create the md0 md1 and md2
devices. I cannot however, get any of these to mount afterwards. I
assume that mount doesn't know what type of fs these are and I'm not
seeing anything in the docs about what type I can use. 

Eventually this raid set needs to be able to boot. We use grub as the
boot loader. If anyone has done this or knows how and can offer any
assistance I thank you in advance.

We are using 2.4.29 kernel in a home rolled package but have both
raidtools and mdadm tools available.

Cheers!
--p



