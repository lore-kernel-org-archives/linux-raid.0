From: "John Stoffel" <john@stoffel.org>
Subject: Re: help requested for mdadm grow error
Date: Mon, 25 May 2020 17:45:59 -0400
Message-ID: <24268.15511.752645.491837@quad.stoffel.home>
References: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
        <5ECC09D6.1010300@youngman.org.uk>
        <ff4ea9cd-ab35-0990-5946-4a72d4021658@gmail.com>
        <5ECC1488.3010804@youngman.org.uk>
        <4891e1e8-aaee-b36b-4131-ca7deb34defd@gmail.com>
        <5ECC1A86.3010104@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5ECC1A86.3010104@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Thomas Grawert <thomasgrawert0282@gmail.com>, linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

>>>>> "Wols" == Wols Lists <antlists@youngman.org.uk> writes:

Wols> On 25/05/20 20:05, Thomas Grawert wrote:
>> The EFAX had me worried a moment, but these are 12TB Reds? That's fine.
>>> A lot of the smaller drives are now shingled, ie not fit for purpose!
>>> 
>>> Debian 10 - I don't know my Debians - how up to date is that? Is it a
>>> new kernel with not much backports, or an old kernel full of backports?
>>> 
>>> What version of mdadm?
>>> 
>>> 
>>> That said, everything looks good. There are known problems - WITH FIXES
>>> - growing a raid 5 so I suspect you've fallen foul of one. I'd sort out
>>> a rescue disk that you can boot off as you might need it. Once we know a
>>> bit more the fix is almost certainly a rescue disk and resume the
>>> reshape, or a revert-reshape and then reshaping from a rescue disk. At
>>> which point, you'll get your array back with everything intact.
>> 
>> yes, that´s the 12TB WD-Red - I´m using five pieces of it.
>> 
>> The Debian 10 is the most recent one. Kernel version is 4.9.0-12-amd64.
>> mdadm-version is v3.4 from 28th Jan 2016 - seems to be the latest,
>> because I can´t upgrade to any newer one using apt upgrade.

Wols> OW! OW! OW!

Wols> The newest mdadm is 4.1 or 4.2. UPGRADE NOW. Just download and
Wols> build it from the master repository - the instructions are in
Wols> the wiki.

Wols> And if Debian 10 is the latest, kernel 4.9 will be a
Wols> franken-patched-to-hell-kernel ... I believe the latest kernel
Wols> is 5.6?

This is Debian Buster, and it's he's upto date with debian packages,
he's almost certainly in a stable setup.  Now maybe we need to talk
with the Debian package maintainer for mdadm and ask them to upgrade,
or maybe why they haven't updated recently.

Hmm... It looks like debian 10 had mdadm 4.1-1, so that strongly makes
me suspect he's actually running 9.12 of Debian, which is A) what my
main server runs at home, and B) also quite old.  But stable.  

In any case, it's easy enough to git clone the latest release and
compile it.

John
