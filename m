From: Phillip Susi <phillsusi@gmail.com>
Subject: Re: Kernel says there is not a valid superblock, but there is
Date: Tue, 21 Oct 2014 10:07:07 -0400
Message-ID: <5446688B.7030405@gmail.com>
References: <544525C7.7000803@gmail.com> <20141021080937.69aaf214@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141021080937.69aaf214@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/20/2014 5:09 PM, NeilBrown wrote:
> On Mon, 20 Oct 2014 11:09:59 -0400 Phillip Susi <phillsusi@gmail.com> wrote:
> 
>> When trying to assemble, the kernel complains:
> 
> Which kernel?
>   uname -a
> and may as well add
>   mdadm -V
> 
> as well.

uname -a
Linux hyper1 3.13.0-35-generic #62-Ubuntu SMP Fri Aug 15 01:58:42 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux

mdadm -V
mdadm - v3.2.5 - 18th May 2012

I managed to hack around with dmsetup to create a linear mapping to the
correct data offset that mdadm -E listed and recover my data and blow
away and recreate the array.  I saved a dump of the superblock if you
want them for debugging.


