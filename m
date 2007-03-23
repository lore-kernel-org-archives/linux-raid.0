From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Grow a RAID-6 ?
Date: Fri, 23 Mar 2007 16:34:49 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0703231630130.31910@lion.drogon.net>
References: <20061110102955.ljws9mgxf4o4kgw8@my.pengus.net>
 <Pine.LNX.4.64.0703231452540.31910@lion.drogon.net>
 <Pine.GSO.4.64.0703231629090.16183@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.0703231629090.16183@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 Mar 2007, Mattias Wadenstein wrote:

> On Fri, 23 Mar 2007, Gordon Henderson wrote:
>
>> Are there any plans in the near future to enable growing RAID-6 arrays by 
>> adding more disks into them?
>> 
>> I have a 15x500GB - drive unit and I need to add another 15 drives into 
>> it... Hindsight is telling me that maybe I should have put LVM on top of 
>> the RAID-6, however, the usable 6TB it yields should have been enough for 
>> anyone...
>
> Well, if you are doubling the space, you could take this opportunity to put 
> lvm on the new disks, move all the data, then put in the old disks as a pv, 
> extending the lvm space.

Now why didn't I think of that. *thud*

> I really wouldn't recommend having a 30-disk raid6, imagine the rebuild time 
> after a failed disk..

There is that - it would give me 2 disks (ie. 1TB) more space though...

This isn't a performance limited server though, it's an off-site backup 
box, so it just has to be reasonably reliable.

Thanks!

Gordon
