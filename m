From: "D. Lane Ware" <dlware@uchicago.edu>
Subject: mdadm dynamic multipathing
Date: Thu, 31 Aug 2006 12:40:06 -0500 (CDT)
Message-ID: <Pine.SOC.4.61.0608311235360.23597@cove>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Just wondering if there is any way to get mdadm created multipath devices 
to re-activate a previously disabled path?

I know I can

mdadm /dev/md0 -f /dev/sdx -r /dev/sdx -a /dev/sdx

to re-activate it, but I want mdadm to do it on its own.

Will the monitoring tool allow this (running it in daemon mode)?

Is there any plan to include dynamic multipathing in the future?

I've used Sun's disksuite multipathing in the past and IBM's sdd/vpath 
tools and it just worked, so I kind of just expected it here.

Thanks for any help you can provide.


