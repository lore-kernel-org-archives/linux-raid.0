From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Thu, 7 Dec 2017 10:26:16 +0000
Message-ID: <5A291748.8020604@youngman.org.uk>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru>
 <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de>
 <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
 <20171206160346.GA5806@metamorpher.de>
 <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
 <CACsGCyTZaqRxWFJ1NxN3jVktRcQv3_AdjRTT+3OfuYMuFYdr_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyTZaqRxWFJ1NxN3jVktRcQv3_AdjRTT+3OfuYMuFYdr_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/12/17 20:19, Edward Kuns wrote:
> 2) Wol, should there be a section on the Wiki about "Things you should
> make sure you have configured" that includes disabling the BBL (unless
> you know what you're doing), making sure you're scrubbing regularly,
> making sure you have drives that support scterc (or if you don't,
> configuring /sys/block/<device>/device/timeout), and so on?  Perhaps a
> list of information you should have handy before disaster strikes to
> make life a lot easier if it does?  E.g., running lsdrv or dumping
> partition tables to text files or listing information about your RAID
> configuration and LVM, etc.

A lot of that information is there. I'm just very conscious of the need
to make everything read well - too much documentation feels like it's
been thrown together, and is a horrible read.

One piece of documentation is a perfect example of how readers can miss
stuff because it's too obvious ... :-) I had trouble finding out how to
do some operation to do with text entry in a word processor. I couldn't
find any reference to it in the index. I searched high and low. Then
somebody pointed it out to me in the manual - it was repeated on nearly
every other page!

I'm planning to condense a lot of this thread into the "scary things
that are easy to fix" page, but your idea of a checklist page sounds
very good. Expect it to appear some time "soon" :-)

(Note also that a lot of this stuff I don't have personal experience of,
so it only tends to make its way into the wiki when something crops up
on the mailing list.)

Cheers,
Wol
