From: Asdo <asdo@shiftmail.org>
Subject: Re: Why does one get mismatches?
Date: Sat, 20 Feb 2010 12:12:39 +0100
Message-ID: <4B7FC3A7.10104@shiftmail.org>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
 <4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown>
 <4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown>
 <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu> <4B7B0D45.7040801@tmr.com>
 <6db64f7872286165ac1fd3436e9d6476@localhost>
 <20100218100547.7aecdc34@notabene.brown> <20100219151809.GB4995@lazy.lzy>
 <20100220090208.06c1130f@notabene.brown> <4B7F2013.4070905@shiftmail.org>
 <87k4u8zg3t.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <87k4u8zg3t.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> The check is usualy done with the filesystem mounted and in use. So one
> case would be that the block got written, changed and then checked
> before the FS decided to flush the dirty block again.
>
> The other scenario suggested in the past is that the block was written,
> changed and then the file deleted, making the block unused, 
This is not enough to cause the problem if I understand correctly, it 
also needs to change value at this point, right?
So how can it change value... is the same buffer used for another block?
> before it
> got flushed again. The filesystem then sees no need to write a dirty but
> unused block so it never gets rewritten. It never gets read either so
> that  is safe.
>   

