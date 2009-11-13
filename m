From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Fri, 13 Nov 2009 08:04:20 -0500
Message-ID: <4AFD5954.1010706@tmr.com>
References: <19187.50708.551325.297625@notabene.brown> <4AF829B2.5090001@redhat.com>  <4AF836F8.5040903@panix.com> <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com> <alpine.DEB.1.10.0911091749320.22728@uplift.swm.pp.se> <4AF8847D.8030303@redhat.com> <4AFC8B6D.7080603@tmr.com> <alpine.DEB.1.10.0911130644150.14550@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0911130644150.14550@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Doug Ledford <dledford@redhat.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Thu, 12 Nov 2009, Bill Davidsen wrote:
>
>> I like 1.2, I feel it's least likely to suffer collateral damage, and 
>> the problems it causes seem to result in the type of behavior you 
>> mention aboue, the system says "Can't, won't, you don't know what 
>> you're doing."
>
> What about adding a new v1.3 superblock which basically has 4 
> superblocks, an old 1.x superblock residing at <end>-<v1.0 superblock 
> size> (new location), and then pointers to this block residing where 
> 1.0, 1.1 and 1.2 superblocks would normally be? Wouldn't that solve 
> "everybodys" problem by making it easier to find the superblock 
> regardless of what might have happened (drive size changed because of 
> 3ware, someone installed mbr on the drive etc).
>
Is it because it's early in the morning and I haven't had coffee, or is 
that starting to sound like raid-1 with superblocks? I just have to feel 
that it would increase the chances of something "looking like" a 
superblock, but wasn't. Then we could have reshape of superblocks in 
--grow, all in all that idea feels as though it's inviting them to be 
different. Imagine an array with partitions, each of which is in an 
array (like raid-1+0) with superblocks everywhere.

I'm sure other people will have thoughts on this, but given the problems 
we have with mismatch_cnt in mirrors, I wouldn't trust them to stay the 
same. And all would have to be updated, of course, makes for much disk 
writing.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

