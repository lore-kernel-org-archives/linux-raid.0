From: "Kevin P. Fleming" <kpfleming@cox.net>
Subject: Re: How to force raid to stop, cleanly? More info
Date: Wed, 09 Apr 2003 11:33:18 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E94676E.7030301@cox.net>
References: <200304091822.LAA16207@washington.seas.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200304091822.LAA16207@washington.seas.ucla.edu>
To: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Stephen C Woods wrote:

>    Does the md driver support partitions in a meaningful/useful way?

No, the md driver (and many other block drivers in Linux) do not support 
partitions. Yes, you can use your tool of choice to put a partition 
table on the device, but it won't be used.

You can use LVM1/LVM2 to break up your md device into usable chunks 
(which is what I do).

