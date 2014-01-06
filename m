From: "John Stoffel" <john@stoffel.org>
Subject: Re: Looking for some advice on best way to identify drives / recover
 from issues
Date: Mon, 6 Jan 2014 10:57:21 -0500
Message-ID: <21194.53857.185374.195036@quad.stoffel.home>
References: <CAJrqPH9FNtomPygu1XPm2VQpJg3MKX1zUPCt0AOnzQ4GO7YEEQ@mail.gmail.com>
	<52C9A5BB.4090803@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C9A5BB.4090803@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Dylan Distasio <interzone@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Phil" == Phil Turmel <philip@turmel.org> writes:

Phil> I created a script for precisely this type of documentation task, keyed
Phil> to drive serial numbers and UUIDs wherever identifiable.

Phil> https://github.com/pturmel/lsdrv

Phil,

Thanks for the script, it looks good, but I wanted to poke you about
the continuation and corner vars, which are defined with funky graphic
chars.  Would it be hard to put in simpler plain ASCII graphics there
by default, and offer a switch for UTF-8 (???) output?

Also, I wonder if having it going the other way, which is from mount
point down to the device(s) would make sense as well?  Now I just need
to find the time to hack your code and see what I can do.

Thanks!
John
