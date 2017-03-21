From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 13:10:33 +0100
Message-ID: <38410309-344e-dc23-8dc2-bf311231fd1f@thelounge.net>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au>
 <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
 <40485bef-feba-a0ae-5e90-3fc51795c29d@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40485bef-feba-a0ae-5e90-3fc51795c29d@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Am 21.03.2017 um 12:56 schrieb Adam Goryachev:
> Sorry, but I'm just seeing scaremongering and things that don't compute.
> Possibly I'm just not seeing it, but I don't see your advise being given
> by a majority of "experts" either on this list or elsewhere. I'll try to
> refrain from responding beyond this one, and return to lurking and
> hopefully learning more.
>
> Also, please note that the quoting / attribution seems to be wrong
> (inverted).

only in your mail client

> On 21/3/17 22:03, Reindl Harald wrote:
>> Am 21.03.2017 um 11:54 schrieb Adam Goryachev:
>> but the point is that with RAID5/6 the recovery itself is *heavy
>> random IO* and that get *combined* with the random IO auf the normal
>> workload and that means *heavy load on the disks*
> random IO is the same as random IO, regardless of the "cause" of making
> the IO random

no - it's a matter of *how much* random IO you have - when the rebuild 
process needs to seek for parity and remaining data blocks and hence 
produces heavily head movements all over the time this is added to the 
IO of the normal workload

in case of a RAID1/10 rebuild the rbuild process itself is just a linear 
read and the only head moves of the disks is the normal workload on the 
array

> In most systems, you won't be running anywhere near the IO limits, so
> allowing your recovery some portion of IO is not an issue

IO limits don't matter here when we talk about IOPS and drive head moves 
around heavily all the time because parity and data blocks for the 
restore are spread all over the disk *and* the requested workload data 
is also somewhere else

in case of a RAID1/10 rebuild you have all the time linear IO from time 
to time interrupted by the workload on the array - that's a completly 
other stress level for a disk compared with seek for hours and days 
parity and data to restore the data for the failed disk
