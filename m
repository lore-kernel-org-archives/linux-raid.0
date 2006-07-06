From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Can't get md array to shut down cleanly
Date: Thu, 6 Jul 2006 15:48:15 +0200
Message-ID: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Still more problems ... :(

My md raid5 still does not always shut down cleanly. The last few
lines of the shutdown sequence are always as follows:

[...]
Will now halt.
md: stopping all md devices.
md: md0 still in use.
Synchronizing SCSI cache for disk /dev/sdd:
Synchronizing SCSI cache for disk /dev/sdc:
Synchronizing SCSI cache for disk /dev/sdb:
Synchronizing SCSI cache for disk /dev/sda:
Shutdown: hde
System halted.

Most of the time the md array comes up clean on the next boot, often
enough it does not. Having the array rebuild after every other reboot
is not my idea of fun, because the only reason to take it down is to
exchange a failing disk.

Again, help appreciated - I don't dare putting the system into
"production" like that.

Regards

C.
