From: Asdo <asdo@shiftmail.org>
Subject: Reshaping the length of devices
Date: Fri, 12 Mar 2010 16:15:07 +0100
Message-ID: <4B9A5A7B.4070105@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am wondering... is it possible to reshape the length of the underlying 
devices with MD raid?

I mean like in the case one buys larger disks: after moving the raid 
partitions to the new disks half of them is still free. So one might 
want to extend the raid partitions to the end of the disks instead of 
creating another array in the free space.

I have searched the linux-raid mailing list history but I couldn't find 
this topic.

Thanks in advance
