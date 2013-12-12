From: joystick <joystick@shiftmail.org>
Subject: Re: Using Video cards (CUDA) for RAID parity
Date: Thu, 12 Dec 2013 18:51:40 +0100
Message-ID: <52A9F7AC.30209@shiftmail.org>
References: <52A98FAF.4000205@insync.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A98FAF.4000205@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/12/2013 11:27, Pieter De Wit wrote:
> Hi List,
>
> Given the recent work done with techs like CUDA etc. - has the idea 
> been floated to use the video card for RAID parity calculations vs the 
> CPU ?

Sending the XOR computation to the GPU is like shooting a fly with a cannon.

The bandwidth to the GPU would be the bottleneck by 2 orders of 
magnitude if you try to do this.

XOR is a way too simple operation. Even if it was a stream of double * 
double multiplications, the bottleneck would lie in the bandwidth 
to/from the GPU.
You can gain something only if you do a matrix multiplication where each 
float or double is uploaded only once but reused many times in all the 
row x column multiplications.

The best performers on the GPU are the autoctonous applications, which 
operate autonomously and communicate very little with the CPU for a very 
long time.

The XOR computation is WAY fast enough on modern processors. There is a 
benchmark at boot about this:

dmesg | grep "raid6: using algorithm"

returns:

[    5.072162] raid6: using algorithm sse2x4 (7556 MB/s)

7.5 GB/sec, and that's raid6, not even XOR.
Probably even single-threaded.
(probably this does not include the memory-copy overhead)






