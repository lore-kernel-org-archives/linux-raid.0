From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Linux software RAID vs. udev
Date: Fri, 30 Apr 2004 18:25:58 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4092FCA6.2020103@backtobasicsmgmt.com>
Reply-To: kpfleming@backtobasicsmgmt.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm switching my boxes over to udev and fully hotplug-driven /dev 
directories.

However, that means by default I only have /dev/md0 from the MD driver, 
and if I want to "mdadm --assemble" any other array I have to manually 
create the device node for it first.

Is there any chance that mdadm is going to learn how to assemble an 
array without having the device node for it already present? If so, then 
the starting of the array would get the device node created (since it 
would be a new block device) and everything would be happy...

(Please keep my address in the CC list, I'm not subscribed)
