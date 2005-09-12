From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Promise SATAII150 TX4 or raidreconf broken - answer
Date: Tue, 13 Sep 2005 08:50:05 +1000
Message-ID: <4326061D.1020002@eyal.emu.id.au>
References: <430E4AB0.2060600@eyal.emu.id.au> <4313E433.1080602@pobox.com>	<43223709.8090002@eyal.emu.id.au> <x3kfysdq846.fsf@Psilocybe.Update.UU.SE>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <x3kfysdq846.fsf@Psilocybe.Update.UU.SE>
Sender: linux-ide-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Executive summary: it is not the TX4. It is not really raidreconf.
You must specify the parity-algorithm in raidtab because the
raidreconf default is not what one expects.

I have now investigated the corrupted 3->4 disk raidreconf and I
can see that there is a pattern to the problem. A similar pattern
is seen with a 4->5 run.

I wrote known values to the raid before the reconf and checked
after. The process is
	create /dev/md0
	write to it
	raidreconf it
	read it and see which blocks show up where

What I see is that the 2nd pair of each 6 blocks is swapped. Here
is the error list for a test with 1 cyl (31 blocks) per disk:

bad block 2 says it is 3
bad block 3 says it is 2
bad block 8 says it is 9
bad block 9 says it is 8
bad block 14 says it is 15
bad block 15 says it is 14
bad block 20 says it is 21
bad block 21 says it is 20
bad block 26 says it is 27
bad block 27 says it is 26
bad block 32 says it is 33
bad block 33 says it is 32
bad block 38 says it is 39
bad block 39 says it is 38
bad block 44 says it is 45
bad block 45 says it is 44
bad block 50 says it is 51
bad block 51 says it is 50
bad block 56 says it is 57
bad block 57 says it is 56
20 errors in 62 blocks

At this point I decided that I must take the TX4 out of the equation.
This is just too regular for a hardware problem. I created four
partitions on one disk and repeated the test. It failed just the same.

I was now reasonably convinced that it is raidreconf that gives me
grief. Nevertheless, the pattern is just too regular. Maybe the program
does not agree with md on the parity algorithm? The default is said
to be left-symmetric (see man mdadm; man raidtab does not say), so I
specified this explicitly in the raidtab and it started working.

Good, but I needed to understand this.

Looking at the raidtools code (where raidreconf is built), I think
that it does not default to left-symmetric. It looks to me like the
config struct is malloced and zeroed (with memset) meaning the .layout
member is set to left-asymmetric (see top of parser.c) and I do not
see that it is ever set to any other default (left-symmetric would
be numeric 2).

--
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat

