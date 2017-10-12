From: Phil Turmel <philip@turmel.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Thu, 12 Oct 2017 09:04:54 -0400
Message-ID: <ecbbf0ae-3bf8-fe66-79e1-e8207bc09dcc@turmel.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
 <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
 <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
 <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
 <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org>
 <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
 <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org>
 <59DF4B80.5010807@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59DF4B80.5010807@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Alexander Shenkin <al@shenkin.org>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/12/2017 07:01 AM, Wols Lists wrote:
> On 12/10/17 10:50, Alexander Shenkin wrote:
>> Thanks Phil... Googling around, I haven't found a way to change it
>> either, but then again, I'm not really sure what to search for.
>>
>> What about changing my default disk timeout to something less than 120
>> secs?  Say, 100 secs instead of 180?

Nope.  The number has to be longer than the actual longest timeout of
your drive, which we now know is >120.  When I first investigated this
phenomenon years ago, I picked 120 for my timeouts.  Other reports
reached the list with the need for longer, and the recommendation for
180 was chosen.

If the driver times out, it resets the SATA connection while the drive
is still in la-la land.  MD gets the error and tries to write the fixed
sector.  The SATA connection is still resetting at that point, and MD
gets a *write* error, which boots that drive out of the array.

>> Seems like this issue should probably make it into the timeout wiki
>> page, no?  Perhaps some instructions on how to query your system's
>> hangcheck timeout, and thus making sure that you set your drive timeouts
>> to less than that?
> 
> Very much so. What is a "hangcheck timeout"?

Maybe compiled into the kernel.  I vaguely recall seeing some of this
when I used to read (most of) lkml.  Haven't had time for lkml in years.

I'll dig around later if no-one beats me to it.

Phil
