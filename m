From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Idea: reduce SCST processes per LUN
Date: Fri, 06 Dec 2013 17:29:02 +0100
Message-ID: <52A1FB4E.9000503@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Uwe Geier <uwe.geier@profitbricks.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, dcops <dcops@profitbricks.com>
List-Id: linux-raid.ids

Hi Uwe,

my idea was to reduce the number of SCST processes per LUN on the
storage servers as the default is 8. It can be changed live, I've tested.

But I've also seen that on storage1703 and storage1804 it is already set
to 1.

$ for i in `ls -1 /sys/kernel/scst_tgt/devices`; do cat
/sys/kernel/scst_tgt/devices/$i/threads_num; done

So there seems to be no possibility to further reduce the number of
kernel processes.

Cheers,
Sebastian
