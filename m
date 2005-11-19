From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: no reconstruction in 2.6.14.2?
Date: Sat, 19 Nov 2005 18:01:23 -0200
Message-ID: <17279.33939.476421.616066@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've just installed a new server with a 5-disk raid5 and kernel
2.6.14.2. To check something I did a hard reset without shutdown and
on reboot the machine didn't do any automatic resync; all arrays are
shown clean.

Is this some automatic intent-logging or another 2.6 feature (the
machine had been really idle for minutes before the reset)??? This is
my first 2.6 raid5 and with 2.4 resync does happen...
