From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why does one get mismatches?
Date: Sat, 20 Feb 2010 05:27:34 +0100
Message-ID: <87k4u8zg3t.fsf@frosties.localdomain>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
	<4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown>
	<4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown>
	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
	<4B7B0D45.7040801@tmr.com>
	<6db64f7872286165ac1fd3436e9d6476@localhost>
	<20100218100547.7aecdc34@notabene.brown>
	<20100219151809.GB4995@lazy.lzy>
	<20100220090208.06c1130f@notabene.brown>
	<4B7F2013.4070905@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B7F2013.4070905@shiftmail.org> (asdo@shiftmail.org's message of
	"Sat, 20 Feb 2010 00:34:43 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Asdo <asdo@shiftmail.org> writes:

> Thank you for your explanation Neil,
>
> Neil Brown wrote:
>> When memory changes between being written to one device and to another, this
>> does not cause corruption, only inconsistency. Either the block will be
>> written again consistently soon, or it will never be read.
>
> This is the crucial part...
>
> Why would the filesystem reuse the same memory without rewriting the
> *same* block?
>
> Can the same memory area be used for another block?
> If yes, I understand. If not, no I don't understand why the block is
> not eventually rewritten to contain equal data on both disks.
>
> Is this a power-fail-in-the-middle thing, or it can happen even when
> the power is always on?

The check is usualy done with the filesystem mounted and in use. So one
case would be that the block got written, changed and then checked
before the FS decided to flush the dirty block again.

The other scenario suggested in the past is that the block was written,
changed and then the file deleted, making the block unused, before it
got flushed again. The filesystem then sees no need to write a dirty but
unused block so it never gets rewritten. It never gets read either so
that  is safe.

> Do I understand correctly that raid-456 is instead safe
> ("no-mismatch") because it copies the memory region?
>
> Thank you

MfG
        Goswin
