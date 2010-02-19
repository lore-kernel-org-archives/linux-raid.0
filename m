From: Asdo <asdo@shiftmail.org>
Subject: Re: Why does one get mismatches?
Date: Sat, 20 Feb 2010 00:34:43 +0100
Message-ID: <4B7F2013.4070905@shiftmail.org>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
 <4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown>
 <4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown>
 <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu> <4B7B0D45.7040801@tmr.com>
 <6db64f7872286165ac1fd3436e9d6476@localhost>
 <20100218100547.7aecdc34@notabene.brown> <20100219151809.GB4995@lazy.lzy>
 <20100220090208.06c1130f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20100220090208.06c1130f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bill Davidsen <davidsen@tmr.com>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for your explanation Neil,

Neil Brown wrote:
> When memory changes between being written to one device and to another, this
> does not cause corruption, only inconsistency. Either the block will be
> written again consistently soon, or it will never be read.

This is the crucial part...

Why would the filesystem reuse the same memory without rewriting the 
*same* block?

Can the same memory area be used for another block?
If yes, I understand. If not, no I don't understand why the block is not 
eventually rewritten to contain equal data on both disks.

Is this a power-fail-in-the-middle thing, or it can happen even when the 
power is always on?

Do I understand correctly that raid-456 is instead safe ("no-mismatch") 
because it copies the memory region?

Thank you
