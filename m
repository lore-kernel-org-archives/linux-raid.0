From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Filesystem corruption on RAID1
Date: Mon, 21 Aug 2017 01:38:35 +1000
Message-ID: <5df0037e-fc76-1127-e2e8-c4992b6d216e@websitemanagers.com.au>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
 <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it>
 <5995D377.9080100@youngman.org.uk>
 <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
 <59961DD7.3060208@youngman.org.uk>
 <784bec391a00b9e074744f31901df636@assyoma.it>
 <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com>
 <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it>
 <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se>
 <7d0af770699948fb0ecb66185145be05@assyoma.it>
 <alpine.DEB.2.20.1708201241400.3655@uplift.swm.pp.se>
 <59998974.60103@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59998974.60103@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Mikael Abrahamsson <swmike@swm.pp.se>, Gionatan Danti <g.danti@assyoma.it>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 20/8/17 23:07, Wols Lists wrote:
> On 20/08/17 11:43, Mikael Abrahamsson wrote:
>> On Sun, 20 Aug 2017, Gionatan Danti wrote:
>>
>>> It can be even worse: if fsck reads from the disks with corrupted data
>>> and tries to repair based on these corrupted information, it can blow
>>> up the filesystem completely.
>> Indeed, but as far as I know there is nothing md can do about this. What
>> md could do about it is at least present a consistent view of data to
>> fsck (which for raid1 would be read all stripes and issue "repair" if
>> they don't match). Yes, this might indeed cause corruption but at least
>> it would be consistent and visible.
>>
> Which is exactly what my "force integrity check on read" proposal would
> have achieved, but that generated so much heat and argument IN FAVOUR of
> returning possibly corrupt data that I'll probably get flamed to high
> heaven if I bring it back up again. Yes, the performance hit is probably
> awful, yes it can only fix things if it's got raid-6 or a 3-disk-or-more
> raid-1 array, but the idea was that if you knew or suspected something
> was wrong, this would force a read error somewhere in the stack if the
> raid wasn't consistent.
>
> Switching it on then running your fsck might trash chunks of the
> filesystem, but at least (a) it would be known to be consistent
> afterwards, and (b) you'd know what had been trashed!
In the case where you know there are "probably" some inconsistencies, 
you have a few choices:
1) If you know which disk is faulty, then fail it, then clean the 
superblock and add it. It will be re-written from the known good drive
2) If you don't know which drive is faulty, or both drives accrued 
random write errors, then all you can do is make sure that both drives 
have the same data (even where it is wrong). So just do a check/repair 
which will ensure both drives are consistent, then you can safely do the 
fsck. (Assuming you fixed the problem causing random write errors first).

Your proposed option to read from all (or at least 2) data sources to 
ensure data consistency is an online version of the above process in 
(2), not a bad tool to have available, but not required in this scenario 
(IMHO). It is more useful when you think all drives are OK, and you want 
to be *sure* that they are OK on a continuous basis, not just after you 
think there might be a problem.

While I suspect patches would be accepted, without someone capable of 
actually writing the code being interested, then it probably won't 
happen (until one of those people needs it).

Regards,
Adam
