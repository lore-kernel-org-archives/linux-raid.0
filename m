From: Tim Southerwood <ts@dionic.net>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Thu, 24 Jan 2008 20:30:47 +0000
Message-ID: <4798F577.20007@dionic.net>
References: <4797430E.2020603@dionic.net> <18327.31959.286239.480961@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18327.31959.286239.480961@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Carvalho wrote:
> Tim Southerwood (ts@dionic.net) wrote on 23 January 2008 13:37:
>  >Sorry if this breaks threaded mail readers, I only just subscribed to 
>  >the list so don;t have the original post to reply to.
>  >
>  >I believe I'm having the same problem.
>  >
>  >Regarding XFS on a raid5 md array:
>  >
>  >Kernels 2.6.22-14 (Ubuntu Gutsy generic and server builds) *and* 
>  >2.6.24-rc8 (pure build from virgin sources) compiled for amd64 arch.
> 
> This has been corrected already, install Neil's patches. It worked for
> several people under high stress, including us.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi

I just coerced the patch into 2.6.23.14, reset 
/sys/block/md1/md/stripe_cache_size to default (256) and rebooted.

I can confirm that after 2 hours of heavy bashing[1] the system has not 
hung. Looks good - many thanks. But I will run with a stripe_cache_size 
of 4096 in practise as it improves write speen on my configuration about 
2.5 times.

Cheers

Tim



[1] Rsync > 50GB to raid pluf xfs_fsr + dd 11GB of /dev/zero to same 
filesystem.
