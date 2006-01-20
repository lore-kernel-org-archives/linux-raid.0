From: Reuben Farrelly <reuben-lkml@reub.net>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Fri, 20 Jan 2006 20:51:13 +1300
Message-ID: <43D09671.3010405@reub.net>
References: <26A66BC731DAB741837AF6B2E29C1017D47EA0@xmb-hkg-413.apac.cisco.com>	<Pine.LNX.4.61.0601181427090.19392@yvahk01.tjqt.qr>	<17358.52476.290687.858954@cse.unsw.edu.au>	<43D00FFA.1040401@cfl.rr.com> <17360.5011.975665.371008@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17360.5011.975665.371008@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/01/2006 11:32 a.m., Neil Brown wrote:
> On Thursday January 19, psusi@cfl.rr.com wrote:
>> I'm currently of the opinion that dm needs a raid5 and raid6 module 
>> added, then the user land lvm tools fixed to use them, and then you 
>> could use dm instead of md.  The benefit being that dm pushes things 
>> like volume autodetection and management out of the kernel to user space 
>> where it belongs.  But that's just my opinion...
> 
> The in-kernel autodetection in md is purely legacy support as far as I
> am concerned.  md does volume detection in user space via 'mdadm'.

Hrm.  <puzzled look>   How would I then start my md0 raid-1 array that is 
mounted as the root partition / if I'm not doing this when the kernel is 
starting up?  Because without it I've got no userspace to actually execute.

Some of the other arrays with things like /var and /home could obviously be 
easily assembled soon after the kernel hands over control to userspace before 
the filesystem points are mounted, but for the root I am not quite sure how it 
could work...

reuben
