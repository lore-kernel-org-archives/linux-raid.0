From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: what does md do if it finds an inconsistency?
Date: Sun, 06 May 2007 21:07:53 +1000
Message-ID: <463DB709.8010900@eyal.emu.id.au>
References: <20070506004539.GA17736@lapse.madduck.net> <20070506090642.GA22083@lapse.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070506090642.GA22083@lapse.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

martin f krafft wrote:
> also sprach martin f krafft <madduck@madduck.net> [2007.05.06.0245 +0200]:
> 
>>With the check feature of the recent md feature, the question popped
>>up what happens when an inconsistency is found. Does it fix it? If
>>so, which disk it assumes to be wrong if an inconsistency is found?
> 
> 
> What I meant was of course
> 
>   echo repair > sycn_action
> 
> I am unsure what happens:
> 
>   piper:/sys/block/md7/md# cat mismatch_cnt
>   128
>   piper:/sys/block/md7/md# echo repair > sync_action
>   piper:/sys/block/md7/md# cat sync_action
>   idle
>   piper:/sys/block/md7/md# cat mismatch_cnt
>   128 
> 
> If I do this again, then mismatch_cnt goes to 0. Not the first time.
> 
> md7 : active raid10 sda2[0] sdc2[2] sdb2[1]
>       1373376 blocks 64K chunks 2 near-copies [3/3] [UUU]

The first time it reports that it found (and repaired) 128 items.
It does not mean that you now *have* 128 mismatches.

The next run ('repair' or 'check') will find none (hopefully...)
and report zero.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
