From: Michael Guntsche <mike@it-loops.com>
Subject: Strange initramfs+udev+raid interaction creating /dev/md/*
Date: Thu, 5 Aug 2010 14:49:35 +0200
Message-ID: <20100805124935.GA3346@gibson.comsick.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-hotplug <linux-hotplug@vger.kernel.org>
List-Id: linux-raid.ids

Hi again,

Apparently this is a problem with mdadm-3.1.2 and not udev.
Reverting to 3.1.1 or reverting commit
http://neil.brown.name/git?p=mdadm;a=commitdiff;h=319767b85c2b16d80c235195329470c46d4547b3

as mentioned in bugreport 
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=590319

fixes the issue for me.

Kind regards,
Michael Guntsche
