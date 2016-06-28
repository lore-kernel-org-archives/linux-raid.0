From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 10 / 2 Devices Layout question
Date: Tue, 28 Jun 2016 14:16:13 -0400
Message-ID: <5772BEED.9010404@turmel.org>
References: <CA+3OdkMoF7jZNwsNR282Hvq4qwsKUuPtXaXrKXNUPq_4YD6BDw@mail.gmail.com>
 <5770120D.9050809@turmel.org> <20160628142502.7e69983d@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160628142502.7e69983d@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Paul Roland <paulrolandw@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/28/2016 05:25 AM, Roman Mamedov wrote:
> On Sun, 26 Jun 2016 13:34:05 -0400
> Phil Turmel <philip@turmel.org> wrote:
> 
>> On 06/26/2016 01:20 PM, Paul Roland wrote:
>>
>>> I have two SSDs, and I would like to use md/raid10 (2devices) for
>>> performance reasons.
>>
>> Ok, that's reasonable.
> 
> Maybe I'm missing something, but how is a RAID10 of just two devices is
> considered reasonable without any questions or explanation? What is the actual
> layout that is expected here, and what benefits (or even differences) does it
> have compared to RAID0? I thought you need at least 3 devices (and h/w RAID
> controllers might even require 4) for RAID10 to start making sense.

Paul made a statement that isn't obviously a problem -- raid10 on SSDs
makes a blistering fast general purpose redundant setup.  I use
precisely this setup for my boot and OS devices.  I'd do it for my
databases too if I could afford it.  (Can't justify it for my
performance needs -- darn.)

If Paul had asked whether or not to use raid10, I'd have had follow up
questions on his application.

