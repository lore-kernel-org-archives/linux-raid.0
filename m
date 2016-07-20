From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recovering RAID Volumes from 6 Disks
Date: Wed, 20 Jul 2016 15:53:50 +0100
Message-ID: <578F907E.3070400@youngman.org.uk>
References: <CADsVfeyiiAgxeeATrX9UqmWb+Hr3MCf2_eMPjL8hbD7Gpj5Ksg@mail.gmail.com>
 <578E8616.4000908@youngman.org.uk>
 <CADsVfeyz=KiAqSBe11jjBT-yOWpZp_eyP_BctkjvWC5UPNLXuQ@mail.gmail.com>
 <578F8B2D.5070003@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <578F8B2D.5070003@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Amit Biswas <abiswas@nyu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Looking back at your first post, what I think has happened is that sda
has failed, and sdb has fallen foul of the timeout problem.

IFF I'm right, getting your array back shouldn't be too hard.

Cheers,
Wol

On 20/07/16 15:31, Wols Lists wrote:
> Ummmmm ...
> 
> b,e and f are Barracudas ... I know my 3TB Barracudas are vulnerable to
> the timeout problem. It looks like the 1TB ones probably are as well ...
> 
> While you're waiting for someone else to chime in, read the following
> ... not the best reading ... about why your Barracudas are probably a
> bad choice :-(
> 
> http://marc.info/?l=linux-raid&m=139050322510249&w=2
> http://marc.info/?l=linux-raid&m=135863964624202&w=2
> http://marc.info/?l=linux-raid&m=135811522817345&w=1
> http://marc.info/?l=linux-raid&m=133761065622164&w=2
> http://marc.info/?l=linux-raid&m=132477199207506
> http://marc.info/?l=linux-raid&m=133665797115876&w=2
> http://marc.info/?l=linux-raid&m=142487508806844&w=3
> http://marc.info/?l=linux-raid&m=144535576302583&w=2
> 
> Have you got a spare Constellation lying around? If not, can you get a
> proper raid drive - WD Red or Seagate NAS? Do a ddrescue to copy sda to
> the replacement drive if you can. You don't want to use that to recover
> the array if you can help it, but you might not have much choice, and at
> least you'll have it to hand.
> 
> And do NOT do this until the experts chime in and help, but hopefully
> it's just a case of making sure all your arrays are stopped, running the
> following script
> 
> for x in /sys/block/sd[a-z] ; do
>         echo 180  > $x/device/timeout
> done
> 
> echo 4096 > /sys/block/md0/md/stripe_cache_size
> 
> on the barracudas and re-assembling the array(s). At which point,
> backing up and replacing the barracudas should be extremely high on the
> agenda! It's probably a good idea to go Raid-6 and get 2 or 3TB drives.
> 
> Cheers,
> Wol
> 
> 
> On 19/07/16 23:34, Amit Biswas wrote:
>> Here are the smart reports for all six drives. drive sda was not co-operating...
>>
>> /dev/sda
>>
>> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.2.0-27-generic] (local build)
>> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
>>
>> === START OF INFORMATION SECTION ===
>> Vendor:               /2:0:0:0
>> Product:
>> User Capacity:        600,332,565,813,390,450 bytes [600 PB]
>> Logical block size:   774843950 bytes
>>>> Terminate command early due to bad response to IEC mode page
>>
>> === START OF READ SMART DATA SECTION ===
>>
>> Error Counter logging not supported
>>
>> Device does not support Self Test logging
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

