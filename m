From: Mark Knecht <markknecht@gmail.com>
Subject: Re: SMART detects pending sectors; take offline?
Date: Thu, 12 Oct 2017 06:21:49 -0700
Message-ID: <CAK2H+ecT1Psph5Wm9LrPgYOba6PHKzAs55H1LWiqLD+kaBUQZQ@mail.gmail.com>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de> <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org> <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org> <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
 <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org> <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
 <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org> <59DF4B80.5010807@youngman.org.uk>
 <ecbbf0ae-3bf8-fe66-79e1-e8207bc09dcc@turmel.org> <5b28b0fc-5e4d-9ac3-9a82-7e36f25c5108@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b28b0fc-5e4d-9ac3-9a82-7e36f25c5108@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Oct 12, 2017 at 6:16 AM, Alexander Shenkin <al@shenkin.org> wrote:
> On 10/12/2017 2:04 PM, Phil Turmel wrote:
>>
>> On 10/12/2017 07:01 AM, Wols Lists wrote:
>>>
>>> On 12/10/17 10:50, Alexander Shenkin wrote:
>>>>
>>>> Thanks Phil... Googling around, I haven't found a way to change it
>>>> either, but then again, I'm not really sure what to search for.
>>>>
>>>> What about changing my default disk timeout to something less than 120
>>>> secs?  Say, 100 secs instead of 180?
>>
>>
>> Nope.  The number has to be longer than the actual longest timeout of
>> your drive, which we now know is >120.  When I first investigated this
>> phenomenon years ago, I picked 120 for my timeouts.  Other reports
>> reached the list with the need for longer, and the recommendation for
>> 180 was chosen.
>>
>> If the driver times out, it resets the SATA connection while the drive
>> is still in la-la land.  MD gets the error and tries to write the fixed
>> sector.  The SATA connection is still resetting at that point, and MD
>> gets a *write* error, which boots that drive out of the array.
>
>
> Thanks Phil.  Lots of questions in my head, but all rather newbie-ish and
> don't want to bother folks, so I'll just wait till you experts hash it out
> and then will follow recommendations...
>
> thanks,
> allie

Not an expert here but on my Gentoo systems all running kernel 4.12.12 I
have the hangcheck timer disabled. Using it does not appear to be a
hard requirement.

- Mark
