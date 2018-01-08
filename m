From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: 3-way mirror to RAID-6
Date: Mon, 8 Jan 2018 15:20:14 +0000
Message-ID: <5A538C2E.70400@youngman.org.uk>
References: <CAJH6TXg=uCQMmzSQPHC885naZj3cFOZx2oyx462mCBof9NeU+w@mail.gmail.com>
 <87incu79uw.fsf@notabene.neil.brown.name>
 <CAJH6TXh_u08K+w-na_YQDh0WZWOQ8o14=SEzQmwPVrGPbkWasA@mail.gmail.com>
 <063586b9-6b63-9afe-9edc-dd3a73adf1b4@turmel.org>
 <CAJH6TXiqsd=Zs4t5qAEe19shJFgSAZ1W-95yT041H6OyLbKvfA@mail.gmail.com>
 <1f497643-0ad1-5037-207a-9c999dc79ccd@turmel.org>
 <CAJH6TXj-6hyq2BM4GF0YdYQ27DAembZY0cLUt+BZKo+YySfGOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXj-6hyq2BM4GF0YdYQ27DAembZY0cLUt+BZKo+YySfGOw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/01/18 11:34, Gandalf Corvotempesta wrote:
> So, which is the best procedure to follow to increse the total usable
> space, without loosing redundancy while the system is running ?
> 
> I would like to have some confirms from skilled users in this ML.
> On my own, i would replace one disk per time (fail+remove+add) and
> wait for resync to complete, then, resize the array:

Well, that's certainly not best practice!

If you can, you replace one disk at a time with --replace. That will
copy the drive in-place with *no* reduction in redundancy. Doing a
fail/remove removes one level of redundancy.

Okay, you need spare ports to do a --replace so it's not always
possible, but it's always desirable. And with enough spare ports, you
can replace more than one drive at once, again with NO loss of redundancy.

Cheers,
Wol
