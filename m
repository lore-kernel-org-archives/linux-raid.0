From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm --wait doesn't
Date: Mon, 6 Jul 2009 08:28:28 +1000 (EST)
Message-ID: <1960c8896ff51b4b549b5fbe5fc80459.squirrel@neil.brown.name>
References: <cccedfc60907051035o1753ea61r7098c2ea2c8ded9@mail.gmail.com>
    <4A5112F3.8080504@anonymous.org.uk>
    <cccedfc60907051437l3309ace5mee09baba2bc51a49@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60907051437l3309ace5mee09baba2bc51a49@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: ""@neil.brown.name, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, July 6, 2009 7:37 am, Jon Nelson wrote:

> OK, that's weird. mdadm /dev/md12 --wait doesn't, while mdadm --wait
> /dev/md12 does.
> That doesn't seem right to me.

That's what I get for overloading the single-letter args.
Bother --wait and --write-mostly can be given as -W, and mdadm doesn't
distinguish between those three internally.
So
  mdadm /dev/md12 -wait
chooses MANAGE mode and the --wait is treated like --write-mostly,
and as you haven't given any drives to add in write-mostly mode,
it doesn't nothing.

I probably should fix that one day.

NeilBrown

