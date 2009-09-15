From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Tue, 15 Sep 2009 18:05:53 +0000
Message-ID: <1253037953.7774.131.camel@kiste>
References: <h8nbt5$n8p$1@ger.gmane.org>
	 <70ed7c3e0909150340q4ae91cb1j7eaae473c6d94c9a@mail.gmail.com>
	 <h8nrkn$n8p$5@ger.gmane.org>
	 <70ed7c3e0909150403s4db60837gfd742d5f6960adf0@mail.gmail.com>
	 <70ed7c3e0909151002y5f4690b1j26d33dc297af7795@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909151002y5f4690b1j26d33dc297af7795@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-09-15 at 20:02 +0300, Majed B. wrote:
> Out of curiosity, how will you find the sectors/blocks that
> reconstruct a certain bad sector? Is the data spread to the same block
> number on all disks?

Yes. It's a byte-level operation, actually.

The only part that's moderately tricky is, on RAID6, to determine which
partition the Q drive is. Fortunately, mdadm already contains (almost)
all the necessary logic.

