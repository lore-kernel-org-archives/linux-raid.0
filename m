From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: SMART detects pending sectors; take offline?
Date: Thu, 12 Oct 2017 12:01:20 +0100
Message-ID: <59DF4B80.5010807@youngman.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/10/17 10:50, Alexander Shenkin wrote:
> Thanks Phil... Googling around, I haven't found a way to change it
> either, but then again, I'm not really sure what to search for.
> 
> What about changing my default disk timeout to something less than 120
> secs?  Say, 100 secs instead of 180?
> 
> Seems like this issue should probably make it into the timeout wiki
> page, no?  Perhaps some instructions on how to query your system's
> hangcheck timeout, and thus making sure that you set your drive timeouts
> to less than that?

Very much so. What is a "hangcheck timeout"?

My wife has kindly bought the basics I need for a new PC for my birthday
(yeah! :-) and I've ordered two Seagate Ironwolfs to go with it, so I
will be setting this up from scratch. Raid, KVM, LVM, the works. So
hangcheck timeouts, documenting on the wiki, all the other bits, the
important thing is I'll have a brand new system I can play with that's
not got anything important on it and if the system (software side only,
of course :-) gets trashed, so what. I can try stuff out without
worrying about putting my live system at risk.

But back to topic. I know we have the disk timeout (on desktop drives,
any random number up to 180secs :-). We have the linux i/o wait timeout
- by default 30 secs. And now we have the hangcheck timeout, whatever
that is ...

Cheers,
Wol
