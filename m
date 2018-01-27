From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Implementing Global Parity Codes
Date: Sat, 27 Jan 2018 08:37:23 +0000
Message-ID: <5A6C3A43.6030701@youngman.org.uk>
References: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mostafa kishani <mostafa.kishani@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/01/18 05:47, mostafa kishani wrote:
> Dear All,
> 
> I am going to make some modifications to RAID protocol to make it more
> reliable for my case (for a scientific, and maybe later, industrial
> purpose). For example, I'm going to hold a Global Parity (a parity
> taken across the whole data stripe rather than a row)

Except that what do you mean by "row"? Aren't you using it as just
another word for "stripe"?

 alongside normal
> row-wise parities, to cope with an extra sector/page failure per
> stripe. Do you have any suggestion how can I implement this with a
> moderate effort (I mean what functions should be modified)? have any
> of you had any similar effort?

If I understand you correctly, that's easy. Raid-5 has one parity block
per stripe, enabling it to recover from one lost disk. Raid-6 has two
parity stripes, enabling it to recover from two lost disks, or one
random corrupted block.

Nobody's tried to do it, but it's a simple extension of the current
setup ... why don't you implement what I call "raid-6+", where you can
have as many parity disks as you like - in your case three. You'd need
to take the current raid-6 code and extend it - ignore raid-5 because
while the principle is the same, the detail is much simpler and cannot
be extended.

> I also appreciate if you guide me how can I enable DEBUG mode in mdadm.
> 
Can't help there, I'm afraid.

Cheers,
Wol

