From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Advice requested
Date: Tue, 3 Nov 2015 22:05:06 -0600
Message-ID: <CAPpdf5_0A0r9s5aCQOn3M9etUnw_2SLMVig3pH+4vfKZDh=8kQ@mail.gmail.com>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
	<56367C33.6060703@turmel.org>
	<CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
	<5637842D.1070000@turmel.org>
	<CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
	<5637BCE4.8000006@turmel.org>
	<CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
	<5637FBAC.8000900@turmel.org>
	<CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>
	<56380690.5030600@turmel.org>
	<CAPpdf5-HbrFESY_zhfkZ4=2CtYjgO4bA4LmA+1AHkT+Gv9iY2w@mail.gmail.com>
	<56381406.7070608@turmel.org>
	<CAPpdf59EV2TfpHUiZghAfWW6qy5je686Hg_qAs4xLchrUa=G7w@mail.gmail.com>
	<5638336E.4030400@turmel.org>
	<CAPpdf5-DMFrKRiBXjstJkvqQU1KzqJoL=hfNVqTGjy2HfMcALQ@mail.gmail.com>
	<56383C64.2070807@turmel.org>
	<CAPpdf58=f7YVej5MEFgaw6KvCgn+WBcm=JSrTNbM8AixWdpa1g@mail.gmail.com>
	<5638B208.1050502@turmel.org>
	<CAPpdf58x1eKXTKbvisQGV9KUsMRzEacSifaLLzQkX53YM5c6jg@mail.gmail.com>
	<5638DBEB.1000904@turmel.org>
	<CAPpdf59o0kf1-mgB29AcgH2cpdwBrhazf3NeQUYNa6m9+c6C+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf59o0kf1-mgB29AcgH2cpdwBrhazf3NeQUYNa6m9+c6C+A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 3, 2015 at 10:01 PM, o1bigtenor <o1bigtenor@gmail.com> wrote:
>
>
>
> On Tue, Nov 3, 2015 at 10:08 AM, Phil Turmel <philip@turmel.org> wrote:
>>
>> On 11/03/2015 08:36 AM, o1bigtenor wrote:
>> > On Tue, Nov 3, 2015 at 7:09 AM, Phil Turmel <philip@turmel.org> wrote:
>>
>> >> Just add the other drives back into the array in one step, then let them
>> >> recover.
>> >>
>> >> mdadm /dev/md0 --add /dev/sdc1 --add /dev/sde1
>> >>
>> >> {Use the current names if those aren't correct at this time.}
>>
>> One caveat -- don't do this part until you've corrected your timeout mismatch
>> problem, or any latent UREs will break your array again.
>
>
>
> Read through the references.
>
> How do I do what you suggest?
>
> Dee
