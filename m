From: "NeilBrown" <neilb@suse.de>
Subject: Re: Wierd critical node problem
Date: Tue, 10 Jun 2008 20:06:10 +1000 (EST)
Message-ID: <42492.192.168.1.70.1213092370.squirrel@neil.brown.name>
References: <200806100924.48763.wayne@flashmedia.co.za>
    <58687.192.168.1.70.1213085722.squirrel@neil.brown.name>
    <200806101030.09019.wayne@flashmedia.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200806101030.09019.wayne@flashmedia.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: wayne@flashmedia.co.za
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, June 10, 2008 6:30 pm, Wayne Gemmell wrote:
> Sure thingk.
>
> On Tuesday 10 June 2008 10:15:22 you wrote:
>> I suggest you provide lots more details.
>> Probably
>>   mdadm -Dsv

Damn, I meant to say "-Dsvv" (2 v's) but it doens't really matter,
I think that is a good enough picture.
However....

> I have found the following in my logs,
> Jun  9 17:01:50 lloyd kernel: [   52.912904] mdadm[2656]: segfault at
> 0000000000000004 rip 000000000041724c rsp 00007ffff99d9b30 error 4
>

I suspect this is the real problem.
Which version of mdadm (mdadm -V)?

If these arrays are being assembled by the initrd, you would need
to find out what mdadm is in the initrd, though it is probably
the same as in /sbin.  What distro.  What kernel version?

NeilBrown

