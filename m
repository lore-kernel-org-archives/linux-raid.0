From: Niccolo Rigacci <niccolo@texnet.it>
Subject: Change preferred minor number of an md device?
Date: Mon, 31 Jan 2005 18:13:28 +0100
Message-ID: <200501311813.28516.niccolo@texnet.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi to all, md gurus!

Is there a way to edit the preferred minor of a stopped device?

Alternatively, is there a way to create a raid1 device specifying the 
preferred minor number md0, but activating it provisionally as a different 
minor, say md5? An md0 is already running, so "mdadm --create /dev/md0" 
fails...

I have to dump my /dev/md0 to a different disk (/dev/md5), but when I boot 
from the new disk, I want the kernel to autmatically detect the device 
as /dev/md0.

Many thanks

-- 
Niccolo Rigacci
http://www.texnet.it/
