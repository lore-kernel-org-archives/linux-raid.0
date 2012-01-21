From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Preventative replacement of active RAID1 disks
Date: Sun, 22 Jan 2012 00:50:00 +0800
Message-ID: <4F1AECB8.6020905@fnarfbargle.com>
References: <4F16FB90.5000905@gmail.com> <4F1AE34D.8030209@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1AE34D.8030209@iki.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Jan Ceuleers <jan.ceuleers@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/01/12 00:09, Anssi Hannula wrote:
> On 18.01.2012 19:04, Jan Ceuleers wrote:
>> List,
>>
>> I have two 2-partition RAID1 sets, each with a spare. The SMART info for
>> both active disks suggests that I should replace them. Both of them. I
>> based this on the Seek_Error_Rate in the smartctl -a output (below).
> [...]
>> Model Family:     Seagate Barracuda 7200.12 family
>> Device Model:     ST3500418AS
>>    7 Seek_Error_Rate         0x000f   079   060   030    Pre-fail
>> Always       -       93484948
> [...]
>> Model Family:     Seagate Barracuda 7200.12 family
>> Device Model:     ST3500418AS
>>    7 Seek_Error_Rate         0x000f   079   060   030    Pre-fail
>> Always       -       97304022
> [...]
>
> I don't think these indicate any issue with the drives, all of my
> Seagate disks have random big values in that attribute (from 11717390 to
> 103488378525).
>
The only use you get from the Seek_Error_Rate is if you have multiple of the same drive, with the 
same firmware in the same environment. You can then look for any outliers. I had this with 30 Maxtor 
Maxline-II drives, and looking at the seek error rates across the drives gave you a pretty good 
indicator of a drive that was in trouble as its count varied wildly from that of its siblings. Raw 
counts like that are manufacturer/family/firmware specific and in isolation mean nothing to the layman.

If you've got no reallocations, SMART tells you the drive is ok and you are not noticing any odd 
behaviour the chances of the drive being in distress are pretty slim.


