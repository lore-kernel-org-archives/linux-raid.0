From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: "No such device" on --remove
Date: Thu, 10 May 2007 01:23:27 +0400
Message-ID: <46423BCF.3080702@msgid.tls.msk.ru>
References: <20070508170441.GB4333@scavenger.homeip.net> <f1sc2p$33q$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f1sc2p$33q$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bschubert@q-leap.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bernd Schubert wrote:
> Benjamin Schieder wrote:
> 
> 
>> root@crazyhorse:~# mdadm /dev/md/2 -r /dev/hdh5
>> mdadm: hot remove failed for /dev/hdh5: No such device
>>
>> md1 and md2 are supposed to be raid5 arrays.
> 
> You are probably using udev, don't you? Somehow there's presently
> no /dev/hdh5, but to remove /dev/hdh5 out of the raid, mdadm needs this
> device. There's a workaround, you need to create the device in /dev using
> mknod and then you can remove it with mdadm.

In case the /dev/hdh5 device node is missing, mdadm will complain
"No such file or directory" (ENOENT), instead of "No such device"
(ENODEV).

In this case, as I explained in my previous email, the arrays aren't
running, and the error refers to manipulations (md ioctls) with existing
/dev/md/2.

It has nothing to do with udev.

/mjt
