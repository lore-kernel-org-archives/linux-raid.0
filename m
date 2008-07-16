From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 14:48:08 +1200
Message-ID: <487D6168.6020308@sauce.co.nz>
References: <1216130769.5633.318.camel@sam.localdomain> <487CC660.9030004@ziu.info> <487D09E7.1010805@sauce.co.nz> <Pine.LNX.4.64.0807151831070.32734@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807151831070.32734@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mr. James W. Laferriere wrote:

>     At what level (2.6.26) does one set readahead ?
>     I've searched 'mount' ,  'mdadm' ,  'Documentation/md.txt' .  Where 
> else should I look ?  Obviously I am missing something .

Hi Jim,

/sbin/blockdev --setra 65536 /dev/md5 gets it done here.

Regards,

Richard
