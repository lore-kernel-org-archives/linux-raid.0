From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Journalling filesystem corruption fixed in between?
Date: Wed, 03 Oct 2007 11:19:50 +0400
Message-ID: <47034296.6070301@msgid.tls.msk.ru>
References: <735D322AED9CD711BE53000476917CD0029728C3@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <735D322AED9CD711BE53000476917CD0029728C3@NT-SERVER-5>
Sender: linux-raid-owner@vger.kernel.org
To: "Rustedt, Florian" <florian.rustedt@smartnet.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rustedt, Florian wrote:
> Hello list,
> 
> some folks reported severe filesystem-crashes with ext3 and reiserfs on
> mdraid level 1 and 5.

I guess much more strong evidience and details are needed.
Without any additional information I for one can only make
a (not-so-pleasant) guess about those "some folks", nothing
more.  We're running several dozens of systems on raid1s and
raid5s since 2.4 kernel (and some since 2.2 if memory serves,
with an additional patch for raid functionality), -- nothing
except of usual mostly hardware problems since that.  And
many other people use linux raid and especially ext3 file-
system in production on large boxes with good load -- such
a corruption, be it not a particular system specific (due
to, for example, a bad ram or faulty controller or whatever),
should cause alot of messages here @linux-raid and elsewhere.

/mjt
