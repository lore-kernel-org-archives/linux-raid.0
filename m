From: Michal Soltys <soltys@ziu.info>
Subject: Re: Array read 3 time slower to read after data fully loaded
Date: Thu, 18 Nov 2010 21:43:37 +0100
Message-ID: <4CE58FF9.3050202@ziu.info>
References: <4CE4B9E6.1040802@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE4B9E6.1040802@geograph.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: Zoltan Szecsei <zoltans@geograph.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10-11-18 06:30, Zoltan Szecsei wrote:
> Hi,
> Can anyone please explain this to me?
>
> For the last >30 hours I have been loading some 2.5TB of 200-400MB tiff
> images, from another PC on our internal network, onto this new array.
> Yesterday, during this load process, I copied 10 of these files (about
> 2.5GB) from the array onto the /home directory of the same system.
>
> It took 33 seconds, equating to some 75MB/s.
>
> This morning I came in to find that the load process had finished, so I
> deleted the 10 test files from /home, and redid the identical copy test
> (using bash-history, so: identical).
>
> It took 123 seconds, equating to some 20MB/s.
>
> Que? (as in Manuel from Faulty Towers :-) )
>

Is the situation with reading into /dev/null instead of /home the same ?

As this is reading issue, one thing that came to my mind:

- make sure the kernel is _not_ compiled with  CONFIG_MULTICORE_RAID456. 
It's afaik still experimental and can cause severe slowdowns

