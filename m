From: John McMonagle <johnm@advocap.org>
Subject: optimum blockdev --setra settings
Date: Mon, 18 Apr 2005 20:55:05 -0500
Message-ID: <426464F9.5040301@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anyone establish optimum blockdev --setra settings for raid on a 2.6 kernel?

There has been some discussions on the lvm mailing list.
In the case of lvm on raid sounds like it's best to use 0 on the md and 
disk devices and something around 1024 and 4096 on the lvm devices.
It seems make some sense that it can cause a lot of unneeded reads 
particularly if you have a lot of layers and/or a lot of raid5 drives.

My experiments have been inconclusive.  At least it seems that setting 
read ahead to 0 on the low level devices has no penalty.

John

