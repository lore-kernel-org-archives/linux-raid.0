From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Awful RAID5 random read performance
Date: Tue, 02 Jun 2009 09:14:39 -0600
Message-ID: <4A2541DF.40505@harddata.com>
References: <20090601045710141.GMHE24335@cdptpa-omta04.mail.rr.com>	 <200905312339.12234.tfjellstrom@shaw.ca>	 <4A23CCF0.7030104@harddata.com> <7a329d910906020757vec0de52xb6b7e4557e82c489@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7a329d910906020757vec0de52xb6b7e4557e82c489@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wil Reichert <wil.reichert@gmail.com>
Cc: tfjellstrom@shaw.ca, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wil Reichert wrote:
> On Mon, Jun 1, 2009 at 5:43 AM, Maurice Hilarius <maurice@harddata.com> wrote:
>   
>> Thomas Fjellstrom wrote:
>>     
>>> ..
>>> Yet I've heard NCQ makes some things worse. Some raid tweaking pages tell
>>> you to try disabling NCQ.
>>>
>>>       
>> Not so relevant here.
>> This recommendation to  disable drive NCQ is generally due tot he fact that
>> NCQ implementations by various manufacturers tend
>> to differ in behaviour, and, in some cases , is just plain "broken".
>>     
>
> Not trying to start a flamewar on whos hardware is better, but I'd
> love to get clarification on that last statement.  I've always been
> under the impression Intel gets their NCQ right (works for me).  All
> the reviews I've read on the current set of AMD southbridges indicate
> they don't but I've no personal experience there.  No idea about
> nvidia or the cheap add-in sata cards like Silicon Image.
>
> Wil
>   
 From speaking with hardware RAID card manufacturers support engineers 
over the past few years,
there have been several instances where NCQ implementations were 
incomplete, or faulty, or both.

This seems to have improved a lot over the last year or two, so I think 
it is likely now "OK".

However, from the earlier history  I think there is a tendency for 
people now to assume it is "broken",
and to turn it off.


-- 
Regards, Maurice
