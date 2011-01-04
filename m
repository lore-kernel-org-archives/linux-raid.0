From: "Patrick H." <linux-raid@feystorm.net>
Subject: Re: filesystem corruption
Date: Tue, 04 Jan 2011 00:50:39 -0700
Message-ID: <4D22D14F.8070407@feystorm.net>
References: <4D212D4A.3040003@feystorm.net>	<20110103141603.632fdf3e@notabene.brown>	<4D214B5C.3010103@feystorm.net>	<20110103155630.565341d0@notabene.brown>	<4D215902.9010308@feystorm.net> <20110104163324.70baff54@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104163324.70baff54@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sent: Mon Jan 03 2011 22:33:24 GMT-0700 (Mountain Standard Time)
From: NeilBrown <neilb@suse.de>
To: Patrick H. <linux-raid@feystorm.net> linux-raid@vger.kernel.org
Subject: Re: filesystem corruption
> On Sun, 02 Jan 2011 22:05:06 -0700 "Patrick H." <linux-raid@feystorm.net>
> wrote:
>
>   
>> Ok, thanks for the info.
>> I think I'll solve it by creating 2 dedicated hosts for running the 
>> array, but not actually export any disks themselves. This way if a 
>> master dies, all the raid disks are still there and can be picked up by 
>> the other master.
>>
>>     
>
> That sounds like it should work OK.
>
> NeilBrown
>   
Well, it didnt solve it. if I power the entire cluster down and start it 
back up, I get corruption, on old files that werent being modified 
still. If I power off just a single node, it seems to handle it fine, 
just not the whole cluster.

It also seems to happen fairly frequently now. In the previous setup it 
was probably 1 in 50 failures that there was corruption. Now its pretty 
much a guarantee there will be corruption if I kill it.
On the last failure I did, when it came back up, it re-assembled the 
entire raid-5 array with all disks active and none of them needing any 
sort of re-sync. The disk controller is battery backed, so even if it 
was re-ordering the writes, the battery should ensure that it all gets 
committed.

Any other ideas?

-Patrick
