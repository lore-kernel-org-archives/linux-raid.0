From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Thu, 7 Dec 2017 17:06:50 +0000
Message-ID: <5A29752A.9060007@youngman.org.uk>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru>
 <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de>
 <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
 <20171206160346.GA5806@metamorpher.de>
 <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
 <CACsGCyTZaqRxWFJ1NxN3jVktRcQv3_AdjRTT+3OfuYMuFYdr_w@mail.gmail.com>
 <20171207135832.GA4858@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171207135832.GA4858@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/12/17 13:58, Andreas Klauer wrote:
> On Wed, Dec 06, 2017 at 02:19:17PM -0600, Edward Kuns wrote:
>> 1) If I have bad blocks lists configured, how do I safely remove them?
> 
> --assemble with --update=no-bbl is safe, since it only removes if empty.
> If not empty, likely you'll end up doing --update=force-no-bbl anyway.
>  
>> # smartctl -l scterc,70,70 /dev/sdb ; echo $?
>> smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.8.13-100.fc23.x86_64]
>> (local build)
>> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
>>
>> SCT Commands not supported
>>
>> 0
> 
> It'd be hilarious if the timeout FUD on this list came with advice that 
> didn't even do anything for most people, and nobody ever noticed...
> 
> Unfortunately, it returns 4 here. And there are years old posts that 
> explicitely check for it returning 4, so this shouldn't be new at all.
> 
> Perhaps it's an intermittent error specific to your smartctl version?
> 
> You can just set the timeouts unconditionally, if you really want them.
> 
Except bash is back-to-front. True is 0, anything else is false.

So I'm guessing the above drive you've quoted DOES support erc,
therefore it's returned 0 (true) to say everything's okay.

Does your drive support erc? I guess not? So an error code of 4 is
*correct*, and in the sameple script on the wiki will trigger the code
that sets the *kernel* timeout to 180. My Barracudas return 4 ...

Cheers,
Wol

