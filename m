From: mark delfman <markdelfman@googlemail.com>
Subject: Write cache
Date: Thu, 2 Dec 2010 15:58:51 +0000
Message-ID: <AANLkTim+dHWMeZkdFuRiimmNdkZ04j9tO3DCyOPAdxJK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

Is there any way to use an MD RAID in write through mode?  I
appreciate that there is a performance impact but this is important
from a security prospective....

The likelihood is that I would use RAID0 (I know this sounds like a
contradiction to the above, but the =91drives=92 are probably hardware
RAIDs).  But may use standard RAID6.

I cannot see any way to disable write cache in MD, but I am hopefully
I am simply missing something obvious.

I appreciate any feedback....

Thanks, Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
