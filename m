From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recommendation on new system Arrays
Date: Tue, 10 Jan 2017 15:55:40 +0000
Message-ID: <587503FC.1010402@youngman.org.uk>
References: <4259f5ef-42f7-ad4c-c8af-7b6e5c19354c@gmail.com>
 <d1f5b65b-5a0b-92e1-7fe7-d2a0c45c8998@fnarfbargle.com>
 <bfb6ebec-defe-186d-76c8-f7fbbaf65a70@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bfb6ebec-defe-186d-76c8-f7fbbaf65a70@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/01/17 08:48, Benjammin2068 wrote:
> Most of the major CCTV systems suffer in the same way, and they generally get around it by using "hardware" RAID cards with large RAM buffers (until the BBU wears out and you start getting massive footage loss because they can't get the streams to disk fast enough).
>>
>> If performance is not an issue then a RAID6 being written from a Windows VM on a Linux host works just fine. Pass the md straight through to the Windows VM and let it manage the raw block device.

This made me think. Bear in mind ext tends to over-allocate space to try
and avoid fragmentation. I don't know to what extent it happens
automatically, but this sounds similar to what Brad is recommending. If
you can match your file system to your raid array, such that the
file-system's default allocation unit is one stride of the raid, this
will help avoid RMW thrashing. Pretty obvious, in hindsight, this will
mean strides (mostly) never get split across files so are only ever
allocated and freed as whole units.

Cheers,
Wol
