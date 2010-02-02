From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Re: Moved drives between machines... now, MIA.
Date: Tue, 2 Feb 2010 10:36:55 -0500 (EST)
Message-ID: <a2feb7a4a744445965be6fc943fe34e7.squirrel@webmail.jots.org>
References: <b54b3e55942c56b2ec1f69d80f54eaea.squirrel@webmail.jots.org>
    <7d86ddb91001292023x5986f9e6j5d9c2e4e62d5be06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb91001292023x5986f9e6j5d9c2e4e62d5be06@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You did make a new mdadm.conf with the correct devices for each array
> right? If not try running and seeing if your arrays come up. If they do
> then copy /tmp/mdadm.conf to /etc/mdadm/mdadm.conf
>
> mdadm --examine --scan --config=partitions > /tmp/mdadm.conf mdadm
> --assemble --scan --config=/tmp/mdadm.conf

Hmmm.  I was hoping what I'd been doing had been "wrong" somehow, but what
you've got is pretty much what I did.  And here's the output (which
confuses the living Hell out of me):

ARRAY /dev/md0 level=raid1 num-devices=2
UUID=f2de81aa:ccd40fc9:01dc0b99:e8df86c1
ARRAY /dev/md1 level=raid1 num-devices=2
UUID=837925b3:f9f0e1b1:02f450c9:474613c9
ARRAY /dev/md1 level=raid1 num-devices=2
UUID=b6af942c:119cd1fc:02f450c9:474613c9

(Note how the second half of the last two UUIDs is the same, and the last
two UUIDs are both for /dev/md1.)

Guess it's time to go to the tapes, huh?

Thanks,

-Ken


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

