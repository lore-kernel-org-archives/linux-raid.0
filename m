From: "Rob Bray" <raid@bymeinc.com>
Subject: Re: access *existing* array from knoppix
Date: Wed, 13 Sep 2006 09:48:08 -0400 (EDT)
Message-ID: <45037.192.168.0.1.1158155288.squirrel@bymeinc.com>
References: <200609121352.08834.Dexter.Filmore@gmx.de>
    <200609121607.22031.Dexter.Filmore@gmx.de>
    <Pine.LNX.4.64.0609121008050.19418@p34.internal.lan>
    <200609121637.53998.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609121637.53998.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Am Dienstag, 12. September 2006 16:08 schrieb Justin Piszcz:
>> /dev/MAKEDEV /dev/md0
>>
>> also make sure the SW raid modules etc are loaded if necessary.
>
> Won't work, MAKEDEV doesn't know how to create [/dev/]md0.

mknod /dev/md0 b 9 0
perhaps?

