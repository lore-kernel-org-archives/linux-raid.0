From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid6 check/repair
Date: Tue, 27 Nov 2007 00:08:20 -0500
Message-ID: <474BA644.60101@tmr.com>
References: <474431BF.30103@ph.tum.de> <18244.64972.172685.796502@notabene.brown> <4745B375.4030500@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4745B375.4030500@ph.tum.de>
Sender: linux-raid-owner@vger.kernel.org
To: thiemo.nagel@ph.tum.de
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thiemo Nagel wrote:
> Dear Neil,
>
> thank you very much for your detailed answer.
>
> Neil Brown wrote:
>> While it is possible to use the RAID6 P+Q information to deduce which
>> data block is wrong if it is known that either 0 or 1 datablocks is 
>> wrong, it is *not* possible to deduce which block or blocks are wrong
>> if it is possible that more than 1 data block is wrong.
>
> If I'm not mistaken, this is only partly correct.  Using P+Q redundancy,
> it *is* possible, to distinguish three cases:
> a) exactly zero bad blocks
> b) exactly one bad block
> c) more than one bad block
>
> Of course, it is only possible to recover from b), but one *can* tell,
> whether the situation is a) or b) or c) and act accordingly.
I was waiting for a response before saying "me too," but that's exactly 
the case, there is a class of failures other than power failure or total 
device failure which result in just the "one identifiable bad sector" 
result. Given that the data needs to be read to realize that it is bad, 
why not go the extra inch and fix it properly instead of redoing the p+q 
which just makes the problem invisible rather than fixing it.

Obviously this is a subset of all the things which can go wrong, but I 
suspect it's a sizable subset.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


