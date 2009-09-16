From: "Majed B." <majedb@gmail.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Wed, 16 Sep 2009 12:52:42 +0300
Message-ID: <70ed7c3e0909160252l72ffb28dw1dd6315dad1985a5@mail.gmail.com>
References: <h8nbt5$n8p$1@ger.gmane.org> <70ed7c3e0909150340q4ae91cb1j7eaae473c6d94c9a@mail.gmail.com>
	<h8nrkn$n8p$5@ger.gmane.org> <70ed7c3e0909150403s4db60837gfd742d5f6960adf0@mail.gmail.com>
	<70ed7c3e0909151002y5f4690b1j26d33dc297af7795@mail.gmail.com>
	<1253037953.7774.131.camel@kiste> <70ed7c3e0909151114q7296314du77de369f5e4ea695@mail.gmail.com>
	<1253040282.7774.149.camel@kiste> <70ed7c3e0909160231l4e424ff3y4d4615ebb87c0e82@mail.gmail.com>
	<1253094266.6394.5.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1253094266.6394.5.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That's good, I guess, but I fell into what seems to be a problem yesterday.

I've mentioned before that I have 8 disks in an array. 7 of which
belong to it (degraded), and one doesn't. That outsider disk had bad
sectors. I wrote zeros to the disk yesterday and both Pending and
Offline counts have been reset, but Reallocation count didn't
increase. I did run an immediate offline smartd test after zeroing the
disk...

Does that make sense?!

On Wed, Sep 16, 2009 at 12:44 PM, Matthias Urlichs <matthias@urlichs.de> wrote:
> On Wed, 2009-09-16 at 12:31 +0300, Majed B. wrote:
>> I have a question which would probably sound stupid: If I have a bad
>> blocks output file from dd_rescue, can I reconstruct a bad sector's
>> data by reading the same sector from all disks (using dd if=/dev/sdx
>> of=./bbfix_#number bs=512 count=1 skip=bb_number-1), then run an
>> normal XOR operation, write zeros to the bad block to force sector
>> remap, then dd the XOR output to the said sector?
>
> Well, of course. Assuming that the disk's sector remap works, which was
> my problem, and that we're talking about RAID5.
>
>
>



-- 
       Majed B.
