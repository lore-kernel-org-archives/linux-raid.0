From: "Michael Paul" <radius.mp@verizon.net>
Subject: How to recover linear array
Date: Wed, 25 Jun 2003 21:55:22 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00d301c33b9f$26a85230$1400020a@mike>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



     Hi there..

 Long time lurker here...

 I have a RH 7.3 system that had a fully functioning linear raid array. When
I originally installed the system, I put the /usr, /var, /tmp, /bin, etc,
directories on different drives in order to balance the load a bit. The
problem is that the drive that had /usr, /var and /tmp on it died a horrible
nasty death. The data was unrecoverable.

 Since it now appears that I will have to reinstall and reconfigure
everything, my question is how can I rebuild the linear raid without
destroying the data? IIRC, when you do mkraid it resynchronizes the disks,
destroying the data. Normally, this wouldn't be a problem, but I've been a
bad boy and neglected my backups.

 Any ideas?

Thanks,
Michael


