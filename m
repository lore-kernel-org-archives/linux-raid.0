From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: two questions re. proactive recovery and forced assembly
Date: Sun, 13 Apr 2008 10:36:38 +1200
Message-ID: <48013976.6020705@sauce.co.nz>
References: <c4985c940804100501g5cac252ax129328371c36d397@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c4985c940804100501g5cac252ax129328371c36d397@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

rosenfield.albert@gmail.com wrote:

> Question 2.
> A background scan feature has been discussed a few times, my English
> is limited but I find this explanation to be a good one:
> http://thread.gmane.org/gmane.linux.raid/2206

There is a md RAID feature called "repair", which can be regularly 
scheduled via a cron job and will do a full check and repair of the 
entire array.

This can be initiated with the command:

echo repair > /sys/block/mdX/md/sync_action

where mdX is your array.

More information on md RAID options can be found in the file md.txt, in 
the Documentation directory of the kernel source.

Regards,

Richard
