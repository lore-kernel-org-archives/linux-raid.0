From: Wols Lists <antlists@youngman.org.uk>
Subject: Wiki, raid 10, and my new system :-)
Date: Mon, 16 Oct 2017 14:54:49 +0100
Message-ID: <59E4BA29.4050907@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Raid 10 is a complicated subject what with near and far, and whether it
will grow, etc etc.

I'm planning to raid-10 my swap partition, and while it doesn't matter
in the slightest because destroying and recreating will be no hassle for
swap, I'd like to understand what's going on.

If I remember correctly, there was a thread a little while back on
growing a raid-10? And you can't (for certain values of "can't" :-) do it?

Where's the best place to find info about near, far and offset layouts?
I seem to remember "man md", but is there anywhere better?

To give you an idea of what I'm planning, I've currently got 2 x 4TB
drives that will have a swap partition. I know if I raid-10 that it's
effectively just a raid-1 mirror, but I intend to add a third, and then
probably a fourth, drive. Can you do that? What will the result be? And
for swap especially, does anybody know if I should optimise for read or
write - common sense says they're equally important but as a scientist I
know common sense is not to be trusted :-)

Of course, all this will end up on the wiki :-)

Cheers,
Wol
