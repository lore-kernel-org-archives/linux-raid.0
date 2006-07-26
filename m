From: Bernd Rieke <bernd@rhm.de>
Subject: Re: Grub vs Lilo
Date: Wed, 26 Jul 2006 20:59:07 +0200
Message-ID: <44C7BB7B.4010001@rhm.de>
References: <200607261943.24828.mylists@blue-matrix.org> <ea865p$7o0$1@sea.gmane.org> <44C7ADA6.7020200@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44C7ADA6.7020200@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote on 26.07.2006 20:00:
....
....
 >The thing with all this "my RAID devices works, it is really simple!" 
thing is:
 >for too many people it indeed works, so they think it's good and 
correct way.
 >But it works up to the actual failure, which, in most setups, isn't 
tested.
 >But once something failed, umm... Jason, try to remove your hda 
(pretend it
 >is failed) and boot off hdc to see what I mean ;) (Well yes, rescue 
disk will
 >help in that case... hopefully. But not RAID, which, when installed 
properly,
 >will really make disk failure transparent).
 >/mjt

Yes Michael, your right. We use a simple RAID1 config with swap and  / on
three SCSI-disks (2 working, one hot-spare) on SuSE 9.3 systems. We had to
use lilo to handle the boot off of any of the two (three) disks. But we had
problems over problems until lilo 22.7 came up. With this version of lilo
we can pull off any disk in any scenario. The box boots in any case.

We were wondering when we asked the groups while in trouble with lilo
before 22.7 not having any response. Ok, the RAID-Driver and the kernel
worked fine while resyncing the spare in case of a disk failure (thanks to
Neil Brown for that). But if a box had to be rebooted with a failed disk
the situation became worse. And you have to reboot because hotplug still
doesn't work. But nobody seems to care abou or nobody apart of us has
these problems  ...

We tested the setup again and again until we find a stable setup which works
in _any_ case. Ok, we're still missing hotpluging (seems to be solved 
for aic79
in 2.6.17, we're testing). But when we tried to discuss these problems 
(one half
of the raid-devices go offline on that controle where hotplugging 
occurs) there
was no response, too.

So we came to the conclusion that everybody is working on RAID but nobody
cares about the things around, just as you mentioned, thanks for that.

Bernd Rieke

