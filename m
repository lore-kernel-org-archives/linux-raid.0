From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Kernel oops adding bitmap
Date: Wed, 21 Mar 2012 13:52:27 +0000
Message-ID: <4F69DD1B.8020202@anonymous.org.uk>
References: <4F67627D.8050205@nuclearwinter.com> <20120320083210.4a272426@notabene.brown> <4F67A7C7.1050803@nuclearwinter.com> <CAGqmV7qgQUxndmFzAU=cx3stQryOYRSRGPb_1HX9Nw9Ludot-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qgQUxndmFzAU=cx3stQryOYRSRGPb_1HX9Nw9Ludot-A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/03/2012 13:21, CoolCold wrote:
> Btw, was interested in, where bitmap will be placed when adding it on
> live array? I.e. as it requires some diskspace, we should provide some
> free space, but where it can be taken from if array is already created
> and used by, say filesystem?

There's room allocated in the metadata for it at create time, whether or 
not it's used from create time, ever since bitmaps were introduced. 
Before mdadm 3.1.2, total metadata size depended on the array size, 
because the bitmap size depended on the array size, but from 3.1.2 on 
mdadm allocates 1MB for metadata including the bitmap (which is much 
more than is really needed but helps keep things 1MB-aligned).

Cheers,

John.

