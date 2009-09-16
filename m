From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Wed, 16 Sep 2009 11:44:26 +0200
Message-ID: <1253094266.6394.5.camel@localhost>
References: <h8nbt5$n8p$1@ger.gmane.org>
	 <70ed7c3e0909150340q4ae91cb1j7eaae473c6d94c9a@mail.gmail.com>
	 <h8nrkn$n8p$5@ger.gmane.org>
	 <70ed7c3e0909150403s4db60837gfd742d5f6960adf0@mail.gmail.com>
	 <70ed7c3e0909151002y5f4690b1j26d33dc297af7795@mail.gmail.com>
	 <1253037953.7774.131.camel@kiste>
	 <70ed7c3e0909151114q7296314du77de369f5e4ea695@mail.gmail.com>
	 <1253040282.7774.149.camel@kiste>
	 <70ed7c3e0909160231l4e424ff3y4d4615ebb87c0e82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909160231l4e424ff3y4d4615ebb87c0e82@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2009-09-16 at 12:31 +0300, Majed B. wrote:
> I have a question which would probably sound stupid: If I have a bad
> blocks output file from dd_rescue, can I reconstruct a bad sector's
> data by reading the same sector from all disks (using dd if=/dev/sdx
> of=./bbfix_#number bs=512 count=1 skip=bb_number-1), then run an
> normal XOR operation, write zeros to the bad block to force sector
> remap, then dd the XOR output to the said sector?

Well, of course. Assuming that the disk's sector remap works, which was
my problem, and that we're talking about RAID5.


