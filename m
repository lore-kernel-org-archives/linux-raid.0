From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Customize the error emails of  `mdadm --monitor`
Date: Sat, 02 Jun 2007 18:05:22 +0200
Message-ID: <46619542.6010507@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Is there a way to list the _number_ in addition to the name of a 
problematic component? The kernel trend to move all block devices into 
the sdX namespace combined with the dynamic name allocation renders 
messages like "/dev/sdc1 has problems" meaningless. It would make remote 
server support so much easier, by allowing the administrator to label 
drive trays Component0 Component1 Component2... etc, and be sure that 
the local tech support person will not pull out the wrong drive from the 
system.

Thanks

Peter
