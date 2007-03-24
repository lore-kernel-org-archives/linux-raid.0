From: "Daniel Korstad" <dan@korstad.net>
Subject: RE: Grow a RAID-6 ?
Date: Fri, 23 Mar 2007 21:20:37 -0500
Message-ID: <H0000067000491d5.1174702836.www.korstad.net@MHS>
References: <Pine.LNX.4.64.0703231630130.31910@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703231630130.31910@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: gordon <gordon@drogon.net>, maswan <maswan@acc.umu.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

As I understand it, reshape for RAID6 is coming now.  It is in the 2.6.21 kernel still at rc4 as of today though.  I am looking forward to it, and plan to give it a test run when it released.

I have used lv with my past raid sets and it is very nice, adds some flexibility.  

I have also done a RAID5 reshape that was in an lv.  Unfortunately, at the time I had an older LVM version that did not support pvresize.  So I was stuck with a larger RAID set and my lv would not take advantage of it.

I think I needed LVM version 2.02.06 to solve that and get the pvresize feature. If you are running a relatively new disto that won't be an issue any more.  I think I had FC3 or 4.

-----Original Message-----
From: Gordon Henderson [mailto:gordon@drogon.net] 
Sent: Friday, March 23, 2007 11:35 AM
To: Mattias Wadenstein
Cc: linux-raid@vger.kernel.org
Subject: Re: Grow a RAID-6 ?

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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


