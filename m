From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Software RAID when it works and when it doesn't
Date: Sat, 20 Oct 2007 17:45:03 +0400
Message-ID: <471A065F.9030202@msgid.tls.msk.ru>
References: <14526.1192571833@mdt.ecitele.com>  <87bqaw5tqb.fsf@informatik.uni-tuebingen.de> <1192777672.16416.495.camel@w100> <Pine.LNX.4.64.0710191102110.27246@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710191102110.27246@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Alberto Alonso <alberto@ggsys.net>, Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
[]
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Justin, forgive me please, but can you learn to trim the original
messages when replying, at least cut off the very irrelevant parts?
You're always quoting the whole message, even including the part
after a line consiting of single minus sign "-" - a part that most
MUAs will remove when replying...

> I have a question with re-mapping sectors, can software raid be as
> efficient or good at remapping bad sectors as an external raid
> controller for, e.g., raid 10 or raid5?

Hard disks ARE remapping bad sectors by their own.  In most cases
that's sufficient - there's nothing to do for raid (be it hardware
raid or software) except of perform a write to the bad place, just
to trigger an in-disk remapping procedure.  Even the cheapest drives
nowadays has some remapping capability.

There was an idea some years ago about having an additional layer on
between a block device and whatever else is above it (filesystem or
something else), that will just do bad block remapping.  Maybe it was
even implemented in LVM or IBM-proposed EVMS (the version that included
in-kernel stuff too, not only the userspace management), but I don't
remember details anymore.  In any case, - but again, if memory serves
me right, -- there was low interest in that because of exactly this --
drives are now more intelligent, there's hardly a notion of "bad block"
anymore, at least persistent bad block, -- at least visible to the
upper layers.

/mjt
