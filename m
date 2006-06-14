From: Nix <nix@esperi.org.uk>
Subject: Re: RAID tuning?
Date: Wed, 14 Jun 2006 16:11:17 +0100
Message-ID: <87zmgfn562.fsf@hades.wkstn.nix>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com>
	<17550.2944.728044.154492@cse.unsw.edu.au>
	<448E127F.5010708@comcast.net>
	<Pine.LNX.4.56.0606130906370.27931@lion.drogon.net>
	<Pine.LNX.4.64.0606130620410.8834@p34.internal.lan>
	<Pine.LNX.4.56.0606131124160.27931@lion.drogon.net>
	<448EFCA7.6050603@comcast.net>
	<Pine.LNX.4.56.0606132229110.17860@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0606132229110.17860@lion.drogon.net> (Gordon Henderson's message of "13 Jun 2006 22:38:49 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Adam Talbot <talbotx@comcast.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13 Jun 2006, Gordon Henderson said:
> On Tue, 13 Jun 2006, Adam Talbot wrote:
>> Can any one give me more info on this error?  Pulled from
>> /var/log/messages.
>> "raid6: read error corrected!!"
> 
> Not seen that one!!!

The message is pretty easy to figure out and the code (in
drivers/md/raid6main.c) is clear enough. The block device driver has
reported a read error. In the old days (pre-2.6.15) the drive would have
been kicked from the array for that, and the array would have dropped to
degraded state; but nowadays the system tries to rewrite the stripe that
should have been there (computed from the corresponding stripes on the
other disks in the array), and only fails if that doesn't work.
Generally hard disks activate sector sparing and stop reporting read
errors for bad blocks only when the block is *written* to (it has to do
that, annoying though the read errors are; since it can't read the data
off the bad block, it can't tell what data should go onto the spare
sector that replaces it until you write it).

So it's disk damage, but unless it happens over and over again you
probably don't need to be too conerned anymore.

-- 
`Voting for any American political party is fundamentally
 incomprehensible.' --- Vadik
