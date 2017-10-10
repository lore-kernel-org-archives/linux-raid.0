From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: SMART detects pending sectors; take offline?
Date: Tue, 10 Oct 2017 10:21:43 +0100
Message-ID: <59DC9127.2010102@youngman.org.uk>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
 <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/17 10:00, Alexander Shenkin wrote:
>> Please read up on "timeout mismatch" before your array blows up.
> 
> I have timeouts set on all drives when the system boots, and the same
> script turns on the P300s' SCTERC.

You may notice on the raid wiki that I've started putting up smartctl
output from various drives. It would be nice to have the P300 there.
When you get it, any chance you could email me the output of a "smartctl
-x"? I notice on my Barracudas that I get different output depending on
whether I've turned smarts on (it's disabled by default at power-on), so
obviously I'd like it once smart is enabled :-)

It's meant to give people a place to look to (try to) work out which
drive is suitable for them. I've noticed with the drives I've got and
what people have posted, that output is "weird" for some drives...

Cheers,
Wol
