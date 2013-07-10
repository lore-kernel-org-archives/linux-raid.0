From: Martin Wilck <mwilck@arcor.de>
Subject: mdadm -Db switches array to write-pending?!
Date: Wed, 10 Jul 2013 19:54:09 +0200
Message-ID: <51DD9FC1.2060200@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil, hi all,

I discovered a weird behavior of mdadm -Db - it will switch a RAID array
from read-auto state to write-pending. For DDF (and possibly other
formats) this will cause metadata writes.

If I read the code correctly, the reason is that mdadm -Db will use the
GET_BITMAP_FILE ioctl, which calls md_allow_write(). I saw this on a
CentOS 6.3 kernel but comparing the code I didn't see a difference in
recent kernels.

I am wondering if this is intentional, and if no, if anything could be
done about it. It is certainly surprising behavior.

Regards
Martin
