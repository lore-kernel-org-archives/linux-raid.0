From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 08:03:54 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0803020802370.18550@p34.internal.lan>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>  <alpine.DEB.1.00.0803020741150.13994@p34.internal.lan> <bb145bd20803020456g54be4bcbg1cf7aed132ac7944@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803020456g54be4bcbg1cf7aed132ac7944@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 2 Mar 2008, Christian Pernegger wrote:

>>  Disable NCQ and your problem will go away.
>
> Thank you. Just out of interest - which problem and why?
>
>>  echo 1 > /sys/block/$i/device/queue_depth
>
> I get access denied even as root. FWIW the value is at 1 for the 4
> disks in the raid anyway. The SCSI disk has value 8, which is probably
> irrelevant.
>
> For completeness' sake:
>
> mdadm version: mdadm - v2.6.4 - 19th October 2007
> raid setup command: mdadm --create /dev/md0 --verbose --metadata=1.0
> --homehost=jesus -n4 -c1024 -l5 --bitmap=internal --name tb-storage
> -ayes /dev/sd[bcde]
> cryptsetup command: cryptsetup luksFormat /dev/md0 --align-payload=2048
>
> Any other suggestions on any of the issues?
>
> Thanks,

You could try to change cables and such but you've already cc'd linux-ide, 
AFAIK it can/could be a chipset/related issue and the guys who work on NCQ 
etc are working on the problem is the last I heard..

You should try and narrow down the problem, is it always the same drive 
that has that problem every time?  Does it occur if you do a check on the 
RAID 5 array or only when building?  etc..
