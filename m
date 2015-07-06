From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Re[2]: Issue removing failed drive and re adding on raid 6
Date: Mon, 06 Jul 2015 00:15:44 +0000
Message-ID: <em889cb545-3bef-42b7-a62f-3017009b2df4@littlez>
References: <alpine.DEB.2.02.1507041009040.11810@uplift.swm.pp.se>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1507041009040.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



>I recommend this as minimum (in rc.local for instance):
>
>for x in /sys/block/sd[a-z] ; do
>         echo 180  > $x/device/timeout
>done
>
>echo 4096 > /sys/block/md0/md/stripe_cache_size
>
>
Done. I will see how this nets out for me here. I will work on switching 
over to enterprise or nas rated drives with proper error timing. In the 
meantime, I will keep my LTO backup up to date.

Thanks for your help.

- Justin
>

