From: Peter van Es <vanes.peter@gmail.com>
Subject: Re: Help needed recovering from raid failure
Date: Thu, 30 Apr 2015 21:25:04 +0200
Message-ID: <75230D05-6BFF-4906-921A-15175D6567EB@gmail.com>
References: <C17D8E8D-492C-4BDD-904C-75CCA70B2CD9@gmail.com> <20150430092741.0dc24c39@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150430092741.0dc24c39@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

thanks. I followed your instructions (slightly modified as my version of mdadm did not support the --data-offset stanza). /dev/sdd was the 3rd drive and I had physically removed the 4th drive from my server.

I managed to restart the array. Then I replaced the failing drive, created partitions the same as on /dev/sda and added it to the two arrays.

It is now rebuilding for the data array, and will be done in 440 minutes.... It appears that I've lost nothing important...

One question: I did spot that the Array UUID has changed on the Create command. Is there any way of getting it back to the old value ?

Peter


> 
> Before doing this, double check that the names have changed, so check that
>  mdadm --examine /dev/sda2
> shows
>>     Array UUID : 1f28f7bb:7b3ecd41:ca0fa5d1:ccd008df
>>   Device Role : Active device 0
> 
> (among other info) and  that 
>  mdadm --exmaine /dev/sdb2
> show the same Array UUID and
>>   Device Role : Active device 1
> 
> 
> Then run
> 
> mdadm -C /dev/md1 -l5 -n4 --data-offset=262144s --metadata=1.2 --assume-clean \
>  /dev/sda2 /dev/sdb2 missing /dev/sde2


