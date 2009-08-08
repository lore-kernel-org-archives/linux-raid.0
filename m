From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: partitioned raid 5 and proper partition alignment
Date: Sun, 09 Aug 2009 00:21:35 +0200
Message-ID: <87ws5egd5c.fsf@frosties.localdomain>
References: <200908080812.45509.ml_linux_raid@mortal-soul.de>
	<87skg2vius.fsf@frosties.localdomain>
	<200908081309.59049.ml_linux_raid@mortal-soul.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908081309.59049.ml_linux_raid@mortal-soul.de> (Matthias
	Dahl's message of "Sat, 8 Aug 2009 13:09:59 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Dahl <ml_linux_raid@mortal-soul.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias Dahl <ml_linux_raid@mortal-soul.de> writes:

> Hi.
>
> On Saturday 08 August 2009 09:56:59 you wrote:
>
>> But each stripe only holds 128k of data. You have to align to that.
>
> I beg to differ. There are two data chunks and one parity chunk, thus a whole 
> stripe is 192k long if you've a 64k chunk size. If you align to 128k and you 
> put e.g. ext4 on it with the correct fs stride and stripe-width settings, 
> you'll probably end up with worse performance since you start in the middle of 
> a stripe even though properly aligned to a chunk boundary. Or am I totally on 
> the wrong track here...?!

Yes you are. The filesystem will never ever see the parity block of a
stripe. It only ever sees the 128k data. Writing 128k data will write
a full stripe of 192k to disk.

MfG
        Goswin
