From: Hubert Verstraete <hubskml@free.fr>
Subject: Re: RAID5 losing initial synchronization on restart when one disk
 is spare
Date: Thu, 12 Jun 2008 15:05:57 +0200
Message-ID: <48511F35.90701@free.fr>
References: <48466AD9.5@free.fr>	<484E6C3F.4090204@free.fr>	<484FE4C4.5020100@free.fr> <18512.25101.824044.407896@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18512.25101.824044.407896@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday June 11, hubskml@free.fr wrote:
>> By the way and FYI, with my configuration, all disks on the same 
>> controller, internal bitmap, v1 superblock, ... the initial RAID-5 
>> synchronization duration is the same whether I'm using the option 
>> --force or not.
>
> For this to be a valid test, you need to fill one drive up with
> garbage to ensure that a resync is no a no-op.
>
> If you don't use the "--force" option, then the recovery process will
> read from N-1 drives and write to 1 drive, all completely sequentially
> so it will go at a predictable speed.
>
> When you use "--force" it will read from N drive and check parity.
> When it finds an error it will re-write that parity block.
> So if the parity blocks happen to be all correct (as probably was the
> case in your experiment), it will run nice and fast.  If the parity
> blocks happen to all be wrong (as is likely when first creating an
> array on drives that weren't an array before) it will be much slower.

I've just filled all the drives with /dev/zero and am currently building 
a new array. Is this a valid test or should I fill the drives with 
/dev/random ?

Hubert
