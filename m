From: David Brown <david@westcontrol.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Mon, 13 Feb 2012 13:42:20 +0100
Message-ID: <4F39052C.1080409@westcontrol.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F38FD5D.1010201@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/02/2012 13:09, Stan Hoeppner wrote:
> On 2/12/2012 2:16 PM, CoolCold wrote:
>> First of all, Stan, thanks for such detailed answer, I greatly appreciate this!
>
> You're welcome.  You may or may not appreciate this reply.  It got
> really long.  I tried to better explain the XFS+md linear array setup.
>
>> There are several reasons for this - 1) I've made decision to use LMV
>> for all "data" volumes (those are except /, /boot, /home , etc)  2)
>> there will be mysql database which will need backups with snapshots 3)
>
> So you need LVM for snaps, got it.
>
>> I often have several ( 0-3 ) virtual environments (OpenVZ based) which
>> are living on ext3/ext4 (because of extensive metadata updates on xfs
>> makes it the whole machine slow) filesystem and different LV because
>> of this.
>
> This is no longer the case as of kernel 2.6.35+ with Dave Chinner's
> delayed logging patch.  It's enabled by default in 2.6.39+ and XFS now
> has equal or superior metadata performance to all other Linux
> filesystems.  This presentation is about an hour long, but it's super
> interesting and very informative:
> http://www.youtube.com/watch?v=FegjLbCnoBw
>

OpenVZ is great for many purposes, but one unfortunate point is that 
because it is based on patches to a number of key parts of the kernel, 
it is only rarely re-synced to new kernels.  It is currently stuck on 
2.6.32, which means he can't use this feature (and nor can I - I also 
use OpenVZ and sometimes XFS, though I'm not too bothered about 
squeezing the last drops of performance out of the system).
