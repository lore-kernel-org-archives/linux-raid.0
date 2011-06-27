From: Pavel Hofman <pavel.hofman@ivitera.com>
Subject: Raid auto-assembly upon boot - device order
Date: Mon, 27 Jun 2011 16:15:03 +0200
Message-ID: <4E089067.8010904@ivitera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

We are running a raid1 on top of two raid0's. In this specific case we
cannot use raid10 (different device sizes etc). Upon booting, the raid1
is always started degraded, with one of the raid0's missing. The log
says the missing raid could not be found. However, upon booting
/proc/mdstat lists both the two raid0s OK.

I guess either the raids are assembled in wrong order (no mutual
dependencies considered), or without letting the previously assembled
device to "settle down". I am wondering what would be the proper way to
fix this issue. The raids are huge (over 1TB each) and recovery takes
many hours.

Our mdadm.conf lists the raids in proper order, corresponding to their
dependency.

Thanks a lot for any help or suggestions.

Best regards,

Pavel.
