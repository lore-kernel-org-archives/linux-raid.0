From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Advice requested
Date: Wed, 04 Nov 2015 12:31:46 +0800
Message-ID: <56398A32.1040503@fnarfbargle.com>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>	<5637BCE4.8000006@turmel.org>	<CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>	<5637FBAC.8000900@turmel.org>	<CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>	<56380690.5030600@turmel.org>	<CAPpdf5-HbrFESY_zhfkZ4=2CtYjgO4bA4LmA+1AHkT+Gv9iY2w@mail.gmail.com>	<56381406.7070608@turmel.org>	<CAPpdf59EV2TfpHUiZghAfWW6qy5je686Hg_qAs4xLchrUa=G7w@mail.gmail.com>	<5638336E.4030400@turmel.org>	<CAPpdf5-DMFrKRiBXjstJkvqQU1KzqJoL=hfNVqTGjy2HfMcALQ@mail.gmail.com>	<56383C64.2070807@turmel.org>	<CAPpdf58=f7YVej5MEFgaw6KvCgn+WBcm=JSrTNbM8AixWdpa1g@mail.gmail.com>	<5638B208.1050502@turmel.org>	<CAPpdf58x1eKXTKbvisQGV9KUsMRzEacSifaLLzQkX53YM5c6jg@mail.gmail.com>	<5638DBEB.1000904@turmel.o
 rg>	<CAPpdf59o0kf1-mgB29AcgH2cpdwBrhazf3NeQUYNa6m9+c6C+A@mail.gmail.com> <CAPpdf5_0A0r9s5aCQOn3M9etUnw_2SLMVig3pH+4vfKZDh=8kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf5_0A0r9s5aCQOn3M9etUnw_2SLMVig3pH+4vfKZDh=8kQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/15 12:05, o1bigtenor wrote:
> On Tue, Nov 3, 2015 at 10:01 PM, o1bigtenor <o1bigtenor@gmail.com> wrote:
>>
>>
>>
>> On Tue, Nov 3, 2015 at 10:08 AM, Phil Turmel <philip@turmel.org> wrote:
>>> One caveat -- don't do this part until you've corrected your timeout mismatch
>>> problem, or any latent UREs will break your array again.
>>
>>
>>
>> Read through the references.
>>
>> How do I do what you suggest?

Here's how I do it. This script is run on every bootup.

It iterates through all the drives and uses smartctl to try and set erc 
timeouts. If that fails it assumes the drive does not support it and it 
sets the timeout value to 180 seconds.

#!/bin/bash
for i in /dev/sd? ; do
	if smartctl -l scterc,70,70 $i > /dev/null ; then
		echo -n $i " is good "
	else
		echo 180 > /sys/block/${i/\/dev\/}/device/timeout
		echo -n $i " is  bad "
	fi;
	smartctl -i $i | egrep "(Device Model|Product:)"
	blockdev --setra 1024 $i
done

I have a mix of 15k SAS drives, WD green & red and some left over bits 
and pieces. This ensures the timeouts all match the drives capability.

Regards,
Brad
