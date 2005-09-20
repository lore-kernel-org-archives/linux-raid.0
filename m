From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Tue, 20 Sep 2005 17:36:22 +0200
Message-ID: <20050920153622.GA14287@uio.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17200.9302.242957.23189@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 21, 2005 at 01:01:42AM +1000, Neil Brown wrote:
> Shrinking certainly adds a lot of complications, and you would have t=
o
> start at the 'top' and work backwards.  Probably not worth the effort=
,
> except that people might want to be able to back-out a change...

I worked on EVMS' resizing code prior to doing this, and it seems like =
a
resize was simply doing it the other way without any further complicati=
ons...
I don't know how the underlying block layer in Linux would like it, tho=
ugh.

>> - It leaks memory; it doesn't properly free up the old stripes etc. =
at the
>>   end of the resize. (This also makes it impossible to do a grow and=
 then
>>   another grow without stopping and starting the volumes.)
> I'm sure that can be fixed.

Yes, of course; it's mostly about not having gotten around to doing it =
yet. A
good start would be doing shrink_stripes(), but the =E2=80=9Cfinish up =
the expanding=E2=80=9D
code is currently called from __release_stripe() when the last stripe f=
rom
the old array is freed, and thus is done under the device_lock, and I h=
ad
problems doing memory management under the spinlock. The correct soluti=
on
would probably be moving it into raid5d, outside the spinlock.

> Crash recovery is essential I think.  There are some awkward cases,
> particularly while growing the first few stripes.  I'm sure we can
> work it out together.

Mm, or at least the very first stripe. I'm not really sure if it's wort=
h it,
though; perfect crash recovery is pretty hard (for one, you'd have to d=
isable
all write caching on the destination disks), and I'm not sure how proba=
ble
a power loss 20ms into the resizing is.

>> - It's quite slow; on my test system with old IDE disks, it achieves=
 about
>>   1MB/sec. One could probably make a speed/memory tradeoff here, and=
 move
>>   more chunks at a time instead of just one by one; I'm a bit concer=
ned
>>   about the implications of the kernel allocating something like 64M=
B in one
>>   go, though :-)
> I doubt speed is a top priority.

Well, with multi-terabyte arrays, restriping at those speeds will take
_weeks_, so more speed is always good. I agree that we don't need to be
pushing it very hard, though.

> I'll try to have a read through your code over the next week or so an=
d
> give you more detailed feedback.

OK, thanks. :-) There's a lot of unneeded junk in the patch, BTW (some
reindenting here and there that I don't know where is coming from, plus=
 lots
of temporary added printks), but I guess we can sort out the cleanness =
after
a while. :-)

/* Steinar */
--=20
Homepage: http://www.sesse.net/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
