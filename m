From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: some general questions on RAID
Date: Fri, 05 Jul 2013 09:13:09 +0800
Message-ID: <51D61DA5.9090507@fnarfbargle.com>
References: <1372962602.8716.56.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372962602.8716.56.camel@heisenberg.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/07/13 02:30, Christoph Anton Mitterer wrote:
> Hi.
>
> Well for me personally these are follow up questions to my scenario
> presented here: http://thread.gmane.org/gmane.linux.raid/43405
>
> But I think these questions would be generally interesting an I'd like
> to add them to the Debian FAQ for mdadm (and haven't found real good
> answers in the archives/google).
>
>
> 1) I plan to use dmcrypt and LUKS and had the following stacking in
> mind:
> physical devices -> MD -> dmcrypt -> LVM (with multiple LVs) ->
> filesystems

I have two arrays with dmcrypt on top of MD.
Array 1 is 4 x Seagate 15k SAS drives in a RAID10 f2.
Array 2 is 6 x 240G SSD's in a RAID10 n2.

Array 2 is partitoned. All run ext4.
The CPU is an AMD FX8350. I can max out all arrays with sequential or 
random r/w loads. So dmcrypt is not a limiting factor for me.

When I say max out, I run into bandwidth limits on the hardware before 
dmcrypt gets in the way.

