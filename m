From: Paul Davidson <Paul.Davidson@anu.edu.au>
Subject: Is shrinking raid5 possible?
Date: Mon, 19 Jun 2006 12:30:29 +1000
Message-ID: <44960C45.9050407@anu.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'd like to shrink the size of a RAID5 array - is this
possible? My first attempt shrinking 1.4Tb to 600Gb,

mdadm --grow /dev/md5 --size=629145600

gives

mdadm: Cannot set device size/shape for /dev/md5: No space left on device

which is true but not particularly relevant :). If mdadm
doesn't support this for online arrays, can I do it offline
somehow?

I'd like to retain the ext3 filesystem on this device,
which I have already shrunk to 400Gb with resize2fs.

Thanks for any help,
Paul
