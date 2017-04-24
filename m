From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 14:37:06 +0200
Message-ID: <20170424123706.GA6798@metamorpher.de>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
 <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
 <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
 <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de>
 <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 24, 2017 at 02:13:24PM +0200, Patrik Dahlström wrote:
> I'm afraid it doesn't say that.

You said you found an ext header in the raw data.

If that exists then only thing I can think of is that you ended 
up picking the wrong offset (or disk order) after all.

> I do know that both raids contains only zeros for
> many MB before any data appears.

This could be normal for the 5disk array since that part already 
reshaped and the offset changed and there just could happen to 
be zeroes somewhere in the beginning of a filesystem after the 
first block of metadata.

Basically the 5disk array is supposed to have bogus data at 
the start in your case. But it should turn into valid data 
at whatever point the reshape did not yet reach.

This bogus data makes it hard to determine the correct offset 
but according to the output you showed before the offset should 
be 128M here.

For the 6disk array you should see valid data (starting with 
the filesystem header) for however far the reshape was already done.
Depending on how the filesystem works you might even be able to 
mount it but everything that is located behind the progress point 
would appear corrupted.

Again if one of the disks actually was kicked from the array 
while the grow was going on, you should leave that disk out as missing 
as otherwise it will just appear as wrong data in both arrays.

Regards
Andreas Klauer
