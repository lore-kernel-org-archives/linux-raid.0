From: Anders Nielsen <anielsen@diku.dk>
Subject: How to change the preferred minor
Date: 10 Apr 2002 11:39:38 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1018431578.10844.32.camel@anders>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When I try to boot my box with disks which previously was configured in
other machines md tries to autodetect which array should have a given
minor number.

I use the wonderful :-) mdadm -E and I can see a preferred minor value
which is very nice, but since more than one array is competing for the
same minor number it is kind of difficult for me to figure out what to
put in my /etc/fstab.

Therefore my question is: how do I change the preferred minor value on a
array so I can prevent conflicts? I would of course like to be able to
use mdadm for this job :-)

Thanks,
  Anders Nielsen



