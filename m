From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID5 how chage chunck size from 64 to 128, 256 ? is it possible
 ?
Date: Sun, 10 Feb 2008 04:03:53 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802100403100.13056@p34.internal.lan>
References: <1498963728.20080209074300@j8.com.ru> <alpine.DEB.1.00.0802090414310.27612@p34.internal.lan> <20080209233159.659ce16d@szpak>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080209233159.659ce16d@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 9 Feb 2008, Janek Kozicki wrote:

> Justin Piszcz said:     (by the date of Sat, 9 Feb 2008 04:14:51 -0500 (EST))
>
>> When you reate the array its --chunk or -c -- I found 256 KiB to 1024 KiB
>> to be optimal.
>
> Hello Justin,
>
> what is your typical bonnie++ invocation, to test your configuration?
> Which fields are meaningful for you from this benchmark?
>
> Do you use anything else for benchmarks?
> eg: 'zcav /dev/sda > result' ?
>
>
> I'm asking becuase I want to make some local benchmarks to determine
> best chunk size in my HDD setup.
>
> thanks in advance
> --
> Janek Kozicki                                                         |
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I use the following (3-iterations & average them):

   /usr/bin/time /usr/sbin/bonnie++ -d /x/test -s 16384 -m p34 -n 
16:100000:16:64 > $HOME/test"$i".txt 2>&1

I also use realistic testing as well such as untarring large files (> 
1GiB) etc..

Justin.
