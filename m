From: <peter.greis@ubs.com>
Subject: setup confusion - what to use ?
Date: Tue, 14 Sep 2004 09:37:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6F9171BE257CA742BFBCFA87B8F20F8D030E3C47@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings All,

Perhaps someone could clear up a few questions....

I just took delivery of an ASUS K8NED (AMD 64), which has two sets of onboard SATA controllers. The first is the nVidia nForce3 250Gb (two channels), the second Silicon Image 3114 (four channels).

Using SUSE 9.1, I would like to configure the nForce for RAID 10 (two hitachi 80gb drives), and the SI 3114 for RAID 5. Allegedly there is BIOS support for all of this.

What I am not sure of....

1. Should I set anything up with the bios settings, or just ignore them ? I have seen a posted decrying the bios stuff as "crap".

2. Should I use the vendor drivers, or the code provided by Garzik and co ? Any comments ?

3. I have seen the comments that this is not really hardware RAID - does this imply that I should generally follow the software RAID setup (http://www.ram.org/computing/linux/dpt_raid.html) ?

If anyone has set up one of these mobos, I would appreciate hearing from you.

regards,

-Peter
