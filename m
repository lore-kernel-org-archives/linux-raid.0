From: Simon Jackson <sjackson@bluearc.com>
Subject: RE: mdadm and TLER (Time Limited Error Recovery)
Date: Wed, 9 Sep 2009 09:21:16 +0100
Message-ID: <ABFC24E4C13D81489F7F624E14891C860D4C3553@uk-ex-mbx1.terastack.bluearc.com>
References: <299cc2790909071735x6eefd8bsc05ad76fa782cae1@mail.gmail.com>
 <slrnhacpsm.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
 <20090908184837.GA28217@teal.hq.k1024.org> <4AA70604.7020709@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AA70604.7020709@harddata.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This sounds an interesting proposition for RAID 1 setups that I am using.  In a couple of cases I have seen unresponsive drives retrying on a bad block seemingly to lock up my system, or at least slow response significantly.  

In my case I am using Seagate and Hitachi drives.  A look at Wikipedia indicates that on Hitachi there is something called "Command Completion Time Limit" and on Seagate "Error Recovery Control".

Please can anyone tell me how I would go about setting timeout values on these types of drive. Are there utility programs to do this or a Linux 
command.

Thanks Simon.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Maurice Hilarius
Sent: 09 September 2009 02:34
To: Mario 'BitKoenig' Holbe
Cc: linux-raid@vger.kernel.org; iusty@k1024.org
Subject: Re: mdadm and TLER (Time Limited Error Recovery)

Iustin Pop wrote:
> ..
>> Anyways, clarification...
>> The only reason for TLER (Time Limited Error Recovery) is to behave
>> "friendly" toward RAID controllers that timeout disks.
>> In fact, md does not timeout disks as many Hardware RAID controllers do.
>> So, from md's point of view, TLER is useless, i.e. it has no benefit.
>>     
>
> I'm sorry but I disagree here. *Especially* because md is used over
> normal SATA controllers most of the time, TLER is beneficial because the
> drive doesn't go catatonic for minutes at a time trying to recover a bad
> sector, which would (because md doesn't timeout disks) cause md to hung
> up the whole device. TLER will allow md to see the error quickly and
> attempt to rewrite (read) or retry/fail the disk (write) for a bad the
> sector.
>
> Just my understanding of the md stack.
>
> regards,
> iustin
>
>   
I agree.
Before WD implemented this we would see cases quite often where a 
perfectly good drive would get "kicked out"
of a RAID as frequently or even more often, than on a hardware RAID.
TLER management seems to have eliminated most of these cases.



-- 
Regards, Maurice
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
