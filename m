From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: hung grow
Date: Wed, 4 Oct 2017 18:51:25 +0100
Message-ID: <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/17 18:18, Curt wrote:
> Is my raid completely fucked or can I still recover some data with
> doing the create assume clean?

PLEASE PLEASE PLEASE DON'T !!!!!!

I take it you haven't read the raid wiki?

https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

The bad news is your array is well borked. The good news is I don't 
think you have - YET - managed to bork it irretrievably. A create will 
almost certainly trash it beyond recovery!!!

I think we can stop/revert the grow, and get the array back to a usable 
state, where we can force an assemble. If a bit of data gets lost, sorry.

Do you have spare SATA ports? So you have the bad drives you replaced 
(can you ddrescue them on to new drives?). What was the original 
configuration of the raid - you say you lost three drives, but how many 
did you have to start with?

I'll let the experts talk you through the actual recovery, but the steps 
need to be to revert the grow, ddrescue the best of your failed drives, 
force an assembly, and then replace the other two failed drives. No 
guarantees as to how much data will be left at the end, although 
hopefully we'll save most of it.

Cheers,
Wol
