From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Wed, 15 Apr 2020 18:10:40 +0200
Message-ID: <bab00844-905a-8a2e-6063-d28d21adde34@peter-speer.de>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <394a3255-251c-41d1-8a65-2451e5503ef9@teksavvy.com>
 <71886beb-495f-d7d5-75f2-f91a53ed4bd3@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <71886beb-495f-d7d5-75f2-f91a53ed4bd3@peter-speer.de>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "J. Brian Kelley" <jbk@teksavvy.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 15.04.20 17:53, Stefanie Leisestreichler wrote:
> Your hint about btrfs is new to me also even I read the docs in their 
> wiki before. I bet I will find myself in a situation/environment which 
> will be hard to administrate because of a gap of information I was 
> overseeing when I took an action which I shouldn't.

For example, found this right now in the arch forums:
https://bbs.archlinux.org/viewtopic.php?id=246390
I don't know if this is still a case but you'd probably need battery 
backup for your system. I've had cases where a power outage borks btrfs 
irrecoverably.

Post is from 2019...

Really don't know if I should cross this road...
