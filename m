From: Jan Ceuleers <jan.ceuleers@gmail.com>
Subject: Re: Preventative replacement of active RAID1 disks
Date: Sat, 21 Jan 2012 18:01:42 +0100
Message-ID: <4F1AEF76.8000200@gmail.com>
References: <4F16FB90.5000905@gmail.com> <4F1AE34D.8030209@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1AE34D.8030209@iki.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/21/2012 05:09 PM, Anssi Hannula wrote:
> Model Family: Seagate Barracuda 7200.12 family
>> Device Model:     ST3500418AS
>>    7 Seek_Error_Rate         0x000f   079   060   030    Pre-fail
>> Always       -       97304022
> [...]
>
> I don't think these indicate any issue with the drives, all of my
> Seagate disks have random big values in that attribute (from 11717390 to
> 103488378525).
Thanks for your response.

Perhaps the Seek_Error_Rate isn't what's wrong, but something's 
definitely wrong. The read performance on these disks is _extremely_ 
poor. I've decided to go ahead with the replacement, and the first of 
the resyncs is progressing at an erratic rate, anywhere between 30MB/s 
and 17kB/s. At this rate it'll take 24h.
