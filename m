From: Phil Turmel <philip@turmel.org>
Subject: Re: What is the solution for USB HDs
Date: Sun, 11 Dec 2016 22:17:19 -0500
Message-ID: <9481982b-bfda-644e-e160-74b94bbbec0c@turmel.org>
References: <13e51316a11df7b0c9f5ab89392361de@juan-carlos.info>
 <171542c9-1ab8-0993-733d-fbb95467f512@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <171542c9-1ab8-0993-733d-fbb95467f512@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, juca@juan-carlos.info, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/11/2016 05:14 PM, Adam Goryachev wrote:
> On 12/12/16 04:14, juca@juan-carlos.info wrote:
> If you are still having problems after that, then please try to post
> more details on what happens when the drives vanish (eg, kernel logs,
> system logs, etc).
> 
> Also, you might consider an alternative SBC, some have SATA ports
> already available (RPi are the only SBC's I've used, but there are many
> other options/variations).

There's also a kernel boot parameter that can cut off all USB
auto-suspend, which I suspect is part of the problem.  It has been known
for a long time that USB is not robust enough to be trusted in MD arrays.

{ looking around..... }

usbcore.autosuspend=-1

is what you need in your bootloader or builtin to the kernel.

Phil
