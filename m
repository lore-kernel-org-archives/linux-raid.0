From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm Some Makefile changes , Hth , JimL
Date: Mon, 8 Apr 2002 13:22:50 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15537.3338.998757.24915@notabene.cse.unsw.edu.au>
References: <15534.8419.129112.229266@notabene.cse.unsw.edu.au>
	<Pine.LNX.4.44.0204051751270.25112-100000@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Mr. James W. Laferriere on Friday April 5
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday April 5, babydr@baby-dragons.com wrote:
> 
> 	Hello Neil ,  Something funny in the --Detail output from a raid5
> 	array I maintain , see below .  Tia ,  JimL
> 
>  mdadm-0.8.1# mdadm -v -D /dev/md0
> /dev/md0:
>         Version : 00.90.00
>   Creation Time : Sat Apr 14 06:16:46 2001
>      Raid Level : raid5
>      Array Size : 892800 (871.87 MiB 914.22 MB)
>                   ^^^^^^

Thanks:
 I had
     larray_size = array_size << 9;
 when array_size was a "long" and larray_size was "long long"
 so some high bits got lost.
 It is now 
     larray_size = array_size;
     larray_size <<= 9;
 which should work correctly.

NeilBrown
