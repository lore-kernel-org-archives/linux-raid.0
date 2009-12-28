From: "spren.gm@gmail.com" <spren.gm@gmail.com>
Subject: Re: Re: why md/raid5 dont have bad block remap
Date: Mon, 28 Dec 2009 19:49:04 +0800
Message-ID: <200912281948566259320@gmail.com>
References: <de04351e0912280303m16a6eac6mf0adad8cd48fc188@mail.gmail.com>,
 <alpine.DEB.1.10.0912281204480.27231@uplift.swm.pp.se>,
 <de04351e0912280325g3784dc91g26ee0593a6cef439@mail.gmail.com>,
 <alpine.DEB.1.10.0912281227110.27231@uplift.swm.pp.se>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, jin zhencheng <zhenchengjin@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> from:Mikael Abrahamsson
>On Mon, 28 Dec 2009, jin zhencheng wrote:
>
>> I think maybe the disk deal with one write comnd with errror,but  the
>> disk maybe is also ok,and rewrite to other place or  rewrite again
>> will be good.
>>
>> why one write error ,set the whole disk faulty.
>
>If the disk has *WRITE* errors, something is seriously wrong. Read errors 
>is one thing, write errors is completely different.
>
>> Disk if very expensive!
>
>Most drives have at least 2-3 years warranty and that should be used. If 
>the drive has write errors, then it's really time to replace it, it won't 
>be reliable.

I agree, the capacity and safety  of data is the most important issue for raid layer, 
 if a write error happens on one drive, more errors may soonly follow, 
where and how much will be remapped?  it would involve complicated algorithms and may cause serious performance decline.
------------------				 
spren.gm@gmail.com
2009-12-28


