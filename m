From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Bug#763917: mdadm: rounding errors in human_size()
Date: Fri, 05 Dec 2014 13:28:00 +0300
Message-ID: <548188B0.6000309@msgid.tls.msk.ru>
References: <20141003182454.GA9120@goneko.de> <20141003182454.GA9120@goneko.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141003182454.GA9120@goneko.de>
Sender: linux-raid-owner@vger.kernel.org
To: 763917@bugs.debian.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil, will you take the patch in this bugreport for the next version?

http://bugs.debian.org/763917.

Thanks,

/mjt

On Fri, 3 Oct 2014 20:24:54 +0200 Jan Echternach <jan@goneko.de> wrote:
> Package: mdadm
> Version: 3.3.2-1
> Severity: minor
> Tags: patch
> 
> 
> While setting up a new system, I noticed an incorrect value in the output
> of mdadm --examine:
> 
>  Avail Dev Size : 2095080 (1023.16 MiB 1072.68 MB)
> 
> The 1023.16 MiB were quite irritating because the underlying partition has
> a size of exactly 1023 MiB.
> 
> The number of sectors seems plausible: 2095080 sectors * 512 bytes/sector
> are 1022.988 MiB or 1072.681 MB. I looked into the code and found an
> inaccuracy in human_size() and human_size_brief(). The formula used for
> the MiB value is essentially
> 
>   long cMiB = (bytes / ( (1LL<<20) / 200LL ) +1) /2;
> 
> but (1LL<<20) / 200LL is not an integer. It's rounded down and cMiB becomes
> too large. The quick fix would have been multiplying by 200 before dividing
> by 1<<20, but that might cause integer overflows in the GiB case.
> 
> The following patch uses a more complicated formula that computes the
> fractional portion separately from the integer portion. It also changes some
> longs to long longs to eliminate a different cause of integer overflows.
> 
> 
> --- mdadm-3.3.2/util.c	2014-10-03 19:06:51.000000000 +0200
> +++ mdadm-3.3.2/util.c	2014-10-03 19:08:06.000000000 +0200
> @@ -671,15 +671,17 @@
>  	if (bytes < 5000*1024)
>  		buf[0] = 0;
>  	else if (bytes < 2*1024LL*1024LL*1024LL) {
> -		long cMiB = (bytes / ( (1LL<<20) / 200LL ) +1) /2;
> +		long cMiB = bytes / (1LL<<20) * 100
> +			    + ((bytes % (1LL<<20)) * 200 / (1LL<<20) +1) /2;
>  		long cMB  = (bytes / ( 1000000LL / 200LL ) +1) /2;
>  		snprintf(buf, sizeof(buf), " (%ld.%02ld MiB %ld.%02ld MB)",
>  			cMiB/100 , cMiB % 100,
>  			cMB/100, cMB % 100);
>  	} else {
> -		long cGiB = (bytes / ( (1LL<<30) / 200LL ) +1) /2;
> -		long cGB  = (bytes / (1000000000LL/200LL ) +1) /2;
> -		snprintf(buf, sizeof(buf), " (%ld.%02ld GiB %ld.%02ld GB)",
> +		long long cGiB = bytes / (1LL<<30) * 100
> +				 + ((bytes % (1LL<<30)) * 200 / (1LL<<30) +1) /2;
> +		long long cGB  = (bytes / (1000000000LL/200LL ) +1) /2;
> +		snprintf(buf, sizeof(buf), " (%lld.%02lld GiB %lld.%02lld GB)",
>  			cGiB/100 , cGiB % 100,
>  			cGB/100, cGB % 100);
>  	}
> @@ -706,12 +708,14 @@
>  		buf[0] = 0;
>  	else if (prefix == IEC) {
>  		if (bytes < 2*1024LL*1024LL*1024LL) {
> -			long cMiB = (bytes / ( (1LL<<20) / 200LL ) +1) /2;
> +			long cMiB = bytes / (1LL<<20) * 100
