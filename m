From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm - raid6 best practices ?
Date: Fri, 22 Sep 2017 20:24:49 +0100
Message-ID: <59C56381.3030704@youngman.org.uk>
References: <CAMNNMLHLA8mEEKpX8UAXgZPYXyL+mhSBC74K_azC25z=+VAc7w@mail.gmail.com>
 <20170922182607.1977620-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170922182607.1977620-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: nkshirsa@redhat.com
List-Id: linux-raid.ids

On 22/09/17 19:26, Song Liu wrote:
> I would say this is a tradeoff between space overhead (2 parity disks per
> array) and data reliability (mean time before data loss, MTBDL, or MTTF).
> Space overhead is easy to calculate. For MTBDL, there are various of
> documents online, for example:
> 
> https://jontse.com/courses/files/cornell/ece5730/Lecture24.pdf
> 
> For your questions:
> 
>> a) recommended number of disks included in RAID array set?
> I would personally recommend 12 to 15 HDDs per array.
> 
My gut feel too was that 84 is an awful lot of disks ...

>> b) Is it possible to include all 84 disks in one array and leave 2 of
> them as host spare?

Do you mean hot spare, or were you thinking of raid-6's two parity disks?

The problem with a hot spare is exactly that - when the array is powered
up, they will be powered up. Yes, with an array that size I guess you
really do want a bunch of hot spares configured, but I'm not sure that's
really a good use of disks. If your main disks are beginning to die, the
spares could easily be going the same way :-(

> It is possible, but not recommended. 84 disks per array really hurts
> reliability.
> 
>> c) Is there a raid6 best practices document to refer to ?

> I am not aware of such documents.
> 
I don't know as it's really a "best practices" document, but there's a
fair bit in the archaeology section of the website you might find
interesting. More about optimisation and speed tests and stuff, but
because it was all old when we started updating the site last year,
that's why it ended up in archaeology.

One thing you really must do is regular scrubs. And MAKE SURE that you
have lots of active and passive monitoring - it would be oh so easy to
lose three disks the moment the guy on watch gets casual and stops
checking ... I don't have access to the stats off the top of my head,
but with that many disks, losing a couple a month to failures doesn't
seem that far-fetched.

> Hope these help.
> 
If you do come across some stuff (or write it yourself :-) please let me
know - this is exactly the stuff that should be on the website if I can
find it.

> Song

Cheers,
Wol
