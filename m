From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Reading takes 100% precedence over writes for mdadm+raid5?
Date: Thu, 06 Dec 2007 11:11:26 -0500
Message-ID: <47581F2E.7020400@tmr.com>
References: <Pine.LNX.4.64.0712021807260.10289@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712021807260.10289@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> root      2206     1  4 Dec02 ?        00:10:37 dd if /dev/zero of 
> 1.out bs 1M
> root      2207     1  4 Dec02 ?        00:10:38 dd if /dev/zero of 
> 2.out bs 1M
> root      2208     1  4 Dec02 ?        00:10:35 dd if /dev/zero of 
> 3.out bs 1M
> root      2209     1  4 Dec02 ?        00:10:45 dd if /dev/zero of 
> 4.out bs 1M
> root      2210     1  4 Dec02 ?        00:10:35 dd if /dev/zero of 
> 5.out bs 1M
> root      2211     1  4 Dec02 ?        00:10:35 dd if /dev/zero of 
> 6.out bs 1M
> root      2212     1  4 Dec02 ?        00:10:30 dd if /dev/zero of 
> 7.out bs 1M
> root      2213     1  4 Dec02 ?        00:10:42 dd if /dev/zero of 
> 8.out bs 1M
> root      2214     1  4 Dec02 ?        00:10:35 dd if /dev/zero of 
> 9.out bs 1M
> root      2215     1  4 Dec02 ?        00:10:37 dd if /dev/zero of 
> 10.out bs 1M
> root      3080 24.6  0.0  10356  1672 ?        D    01:22   5:51 dd if 
> /dev/md3 of /dev/null bs 1M
>
> Was curious if when running 10 DD's (which are writing to the RAID 5) 
> fine, no issues, suddenly all go into D-state and let the read/give it 
> 100% priority?
>
> Is this normal?

I'm jumping back to the start of this thread, because after reading all 
the discussion I noticed that you are mixing apples and oranges here. 
Your write programs are going to files in the filesystem, and your read 
is going against the raw device. That may explain why you see something 
I haven't noticed doing all filesystem i/o.

I am going to do a large rsync to another filesystem in the next two 
days, I will turn on some measurements when I do. But if you are just 
investigating this behavior, perhaps you could retry with a single read 
from a file rather than the device.

    [...snip...]

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


