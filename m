From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RFC swap over raid1
Date: Thu, 1 Aug 2013 23:01:14 -0300
Message-ID: <CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com>
	<51FAE985.1040809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51FAE985.1040809@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

ops, sorry the first swapon was a typo (control v) sorry, i know using
the swapon lock device, only swapoff and after a mdadm --create could
work in this case, but remove the first swapon... just mdadm create,
and swap over md device is the point here...

the /dev/sda and /dev/sdb was just examples, they can be partitions
without problems

the point is: using swap at two partitions / disks, is "better" than
using a swap over a md raid1? (or any other level?)
other point is... swap have a badblock feature? i think it's not
linux-raid but linux-vm or something like it...
for example if i'm using a disk and swap find a badblock, it will use
it? does swap handle bad blocks? it remove the device? continue using
it? or change the device priority?
