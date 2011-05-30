From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: filesystem-level tool to validate array
Date: Mon, 30 May 2011 09:28:46 +0200
Message-ID: <4DE3472E.6070400@fastmail.fm>
References: <BANLkTi=9mp0v4kn+3ZZP7CtBxE88Ox3_rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=9mp0v4kn+3ZZP7CtBxE88Ox3_rA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Stumpf <mjstumpf@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/29/2011 10:17 PM, Michael Stumpf wrote:
> I'm looking for a filesystem-level tool to perform something similar
> to what badblocks does at the drive level.  I can certainly write it
> on my own (I'd build it as a Perl or Python script), but if someone's
> already invented this..
> 
> (The intended purpose is to validate that there are no quirks/bugs in
> the overall fs.)

Well, that is hard task and I don't know of a single tool. Here is what
is similar to badblocks:
http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/ql-fstest/

And here is a posix test suite:
http://www.tuxera.com/community/posix-test-suite/



Cheers,
Bernd
