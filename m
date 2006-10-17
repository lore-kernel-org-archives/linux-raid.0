From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: resync starts over after each reboot (2.6.18.1)?
Date: Tue, 17 Oct 2006 10:46:25 +0200
Message-ID: <45349861.4010208@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just set up a new Debian unstable box.
It's running 2.6.18.1 kernel.

I created RAID-1 on two disks, with no data or filesystem on it.
As I'm still experimenting with the box, I reboot it quite frequently.

I noticed that RAID-1 resync starts from the very beginning after each 
reboot. Is it normal?


-- 
Tomasz Chmielewski
http://wpkg.org
