From: Jim Moechnig <James.P.Moechnig@syntegra.com>
Subject: array status information on Promise SX6000?
Date: Fri, 28 Jun 2002 12:13:37 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D1C9941.5070803@syntegra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got a Promise SX6000 configured with a 5-drive RAID 5 and one hot 
spare in a Redhat 7.2 system running kernel 2.4.18 with the i2o 
modules.  It seems to work correctly as a block device.

But is there a way to determine the health of the array from within 
Linux?  I deliberately caused one data drive to fail yesterday, and 
the OS seemed blissfully unaware of the change - no messages were 
logged to syslog, dmesg, or the console and the volume remained 
readable and writable.  The card beeped for quite a while, but must 
have finished rebuilding the array overnight because it was no longer 
beeping by morning.  I'd rather not put this thing into production, 
only to have it consume the hot spare without ever telling me and have 
a real problem the next time a drive fails.

Has anyone dealt with this issue before?  Is there some simple, 
obvious tool or functionality I'm overlooking?  Should I try Promise's 
hokey-looking drivers (which we have not yet succeeded in insmodding)?

Thanks.
-- 

Jim Moechnig                       James.P.Moechnig@syntegra.com
Systems Administrator                      phone: (651) 415-4711
Syntegra USA, Inc.                        mobile: (612) 770-5168


