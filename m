From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Implementing Global Parity Codes
Date: Sat, 27 Jan 2018 15:13:48 +0000
Message-ID: <5A6C972C.8070401@youngman.org.uk>
References: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
 <5A6C3A43.6030701@youngman.org.uk>
 <CACm9mdWs0d+Fo32AQ3prMuJhfsmECK2jBw-0O7D-KR=LNWtyvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACm9mdWs0d+Fo32AQ3prMuJhfsmECK2jBw-0O7D-KR=LNWtyvw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mostafa kishani <mostafa.kishani@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/01/18 14:29, mostafa kishani wrote:
> Thanks for your response Wol
> Well, maybe I failed to illustrate what I'm going to implement. I try
> to better clarify using your terminology:
> In the normal RAID5 and RAID6 codes we have one/two parities per
> stripe. Now consider sharing a redundant sector between say, 4
> stripes, and assume that the redundant sector is saved in stripe4.
> Assume the redundant sector is the parity of all sectors in stripe1,
> stripe2, stripe3, and stripe4. Using this redundant sector you can
> tolerate one sector failure across stripe1 to stripe4. We already have
> the parity sectors of RAID5 and RAID6 and this redundant sector is
> added to tolerate an extra sector failure. I call this redundant
> sector "Global Parity".
> I try to demonstrate this as follows, assuming each RAID5 stripe has 3
> data sectors and one parity sector.
> stripe1: DATA1 | DATA2 | DATA3 | PARITY1
> stripe2: PARITY2 | DATA4 | DATA5 | DATA6
> stripe3: DATA7 | PARITY3 | DATA8 | DATA9
> stripe4: DATA10 | DATA11 | PARITY4 | GLOBAL PARITY
> 
> and the Global Parity is taken across all data and parity as follows:
> GLOBAL PARITY = DATA1 X DATA2 X DATA3 X DATA4 X DATA5 X DATA6 X DATA7
> X DATA8 X DATA9 X DATA10 X DATA11 X PARITY1 X PARITY2 X PARITY3
> 
> Where "X" stands for XOR operation.
> I hope it was clear.

OWWW!!!!

Have you done and understood the maths!!!???

You may have noticed I said that while raid-6 was similar in principle
to raid-5, it was very different in implementation. Because of the maths!

Going back to high-school algebra, if we have E *unique* equations, and
U unknowns, then we can only solve the equations if E > U (I think I've
got that right, it might be >=).

With raid-5, parity1 = data1 xor data2 xor data3. Now let's assume
somebody thinks "let's add parity2" and defines parity2 = data1 xor
data2 xor data3 xor parity1. THAT WON'T WORK. Raid-5 relies on the
equation "if N is even, then parity2 is all ones, else parity2 is all
zeroes", where N is the number of disks, so if we calculate parity2 we
add absolutely nothing to our pre-existing E.

If you are planning to use XOR, I think you are falling into *exactly*
that trap! Plus, it looks to me as if calculating your global parity is
going to be a disk-hammering nightmare ...

That's why raid-6 uses a *completely* *different* algorithm to calculate
its parity1 and parity2.

I've updated a page on the wiki, because it's come up in other
discussions as well, but it seems to me if you need extra parity, you
really ought to be going for raid-60. Take a look ...

https://raid.wiki.kernel.org/index.php/What_is_RAID_and_why_should_you_want_it%3F#Which_raid_is_for_me.3F

and if anyone else wants to comment, too? ...

Cheers,
Wol
