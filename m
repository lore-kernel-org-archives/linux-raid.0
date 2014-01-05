From: Phil Turmel <philip@turmel.org>
Subject: Re: Looking for some advice on best way to identify drives / recover
 from issues
Date: Sun, 05 Jan 2014 13:34:35 -0500
Message-ID: <52C9A5BB.4090803@turmel.org>
References: <CAJrqPH9FNtomPygu1XPm2VQpJg3MKX1zUPCt0AOnzQ4GO7YEEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJrqPH9FNtomPygu1XPm2VQpJg3MKX1zUPCt0AOnzQ4GO7YEEQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good afternoon Dylan,

On 01/05/2014 10:04 AM, Dylan Distasio wrote:
> Hi all-

[trim /]

> Unfortunately, I did not take the time to physically label the drives
> in the box (there are close to 20) as I built these, and had been
> meaning to, but life got in the way.  Since I have had no issues with
> these arrays in a very long time, I don't even remember if I split
> them across controllers or what.

[trim /]

> Will that give me enough info to figure out which drive belongs to
> which array?  Does anyone have any other suggestions?  I am not sure
> of the current state of ANY of the arrays that were on this box, but I
> don't want to make things worse by booting this system up with some
> drives missing because I've unplugged them, and having the a bad
> situation get worse.

I created a script for precisely this type of documentation task, keyed
to drive serial numbers and UUIDs wherever identifiable.

https://github.com/pturmel/lsdrv

(If any of your drive serial numbers are entirely numeric, you'll want
the patch shown in the open issues)

HTH,

Phil

