From: "Majed B." <majedb@gmail.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Tue, 15 Sep 2009 21:14:55 +0300
Message-ID: <70ed7c3e0909151114q7296314du77de369f5e4ea695@mail.gmail.com>
References: <h8nbt5$n8p$1@ger.gmane.org> <70ed7c3e0909150340q4ae91cb1j7eaae473c6d94c9a@mail.gmail.com>
	<h8nrkn$n8p$5@ger.gmane.org> <70ed7c3e0909150403s4db60837gfd742d5f6960adf0@mail.gmail.com>
	<70ed7c3e0909151002y5f4690b1j26d33dc297af7795@mail.gmail.com>
	<1253037953.7774.131.camel@kiste>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1253037953.7774.131.camel@kiste>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hmm, so I guess I'm luckier since I run RAID5? (or not because I have
2 bad disks? :p)

When do you expect to have a working application done, by the way?

On Tue, Sep 15, 2009 at 9:05 PM, Matthias Urlichs <matthias@urlichs.de> wrote:
> On Tue, 2009-09-15 at 20:02 +0300, Majed B. wrote:
>> Out of curiosity, how will you find the sectors/blocks that
>> reconstruct a certain bad sector? Is the data spread to the same block
>> number on all disks?
>
> Yes. It's a byte-level operation, actually.
>
> The only part that's moderately tricky is, on RAID6, to determine which
> partition the Q drive is. Fortunately, mdadm already contains (almost)
> all the necessary logic.
>
>



-- 
       Majed B.
