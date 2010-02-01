From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then	disaster
 !!
Date: Mon, 01 Feb 2010 16:51:51 +0100
Message-ID: <4B66F897.8060100@texsoft.it>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene> <4B647E0E.6050609@texsoft.it> <4B64A779.6070809@shiftmail.org> <4B65943A.4040800@shiftmail.org> <4B66B367.6030803@texsoft.it> <20100201132703.GA29849@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100201132703.GA29849@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> modern drives _have_ correctable read errors, it is a fact.
> So if md kicked drives on read error it is also possible to lose all
> data on multiple failures (read errors on more than one drives, or
> read-errors when sparing), that could have been recovered.

But if we assume that modern drives behave like this, we should also
assume that radid 5, 4, 10 and 1 with < 3 devices, are intrinsically
vulnerable, and someway 'deprecated', because a read error on
recostruction after a disk failure can likely occur.

Personally I just reshaped the failed array as a 6-disk raid-6.
I'll also reshape another machine which has 3 disks to have 2 arrays, a
raid-1 with 3 devices and a raid-5, the first to be used for most
valuable data.

>> The new one must at least clearly alert the user that a drive is 
>> getting read errors on raid 1,4,5,10.
> Agreed, now let's define 'clearly alert', besides syslog.

I would use the same mechanism of events used now my mdadm, defining new
CorrectedReadError event ... for raid-6 it can be info  (or warning when
errors becamo too many,configurable); for other raid levels (the
'vulnerable' ones) the severity should be warning or critical.

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore



