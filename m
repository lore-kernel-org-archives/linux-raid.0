From: Asdo <asdo@shiftmail.org>
Subject: Re: Is shrinking raid5 possible?
Date: Fri, 06 Nov 2009 16:04:52 +0100
Message-ID: <4AF43B14.60804@shiftmail.org>
References: <44960C45.9050407@anu.edu.au> <17558.10906.59066.196870@cse.unsw.edu.au> <449B3A80.4070602@tmr.com> <17563.17224.85968.572754@cse.unsw.edu.au> <bb145bd20606231116g7808e467w29a9bf273ba0df52@mail.gmail.com> <17567.36792.303403.35943@cse.unsw.edu.au> <bb145bd20606260433w2bafccfdu3448732f5b5c1c5f@mail.gmail.com> <4564B5C3.9050501@idgmail.se> <20091106131740.GA30506@Toms.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091106131740.GA30506@Toms.NET>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Arthur Oehser <tom@toms.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thomas Arthur Oehser wrote:
> Oooh, what would I want to do with "n small partitions"?  I know!  Raid!
>
> Scenario:
>
> existing:
> sda1 sdb1 sdc1 254M + 254M + 254M = 254M raid-1 /boot
> sda2 sdb2 sbc2 2G + 2G + 2G = 6G raid-0 swap
> ...
>   
Putting swap in a raid-0 will hang your computer as soon as sda, sdb or 
sdc fails.
Are you OK with that?


