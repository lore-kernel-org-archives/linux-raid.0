From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: raid 5 crashed
Date: Wed, 1 Jun 2016 00:23:09 -0500
Message-ID: <CACsGCySR8NwbwRY=xe32YzyeZPFMmeDbnqp-LbykPoGBc537qA@mail.gmail.com>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
	<20160511131524.GA11811@cthulhu.home.robinhill.me.uk>
	<CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
	<CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
	<CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
	<574C8EB9.3070706@youngman.org.uk>
	<CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
	<574D958F.8060209@turmel.org>
	<574DDCBD.40801@youngman.org.uk>
	<95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com>
	<CACsGCyQuPEXtgeW6QH-s_-eW9-SZ3J5s2s7CUzZRNemexTt3aw@mail.gmail.com>
	<20b1858b-0cd7-a7de-82af-9167dbcfb09e@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20b1858b-0cd7-a7de-82af-9167dbcfb09e@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 01/06/16 11:46, Edward Kuns wrote:
> My understanding is that mdraid will kick out a drive with an
> unrecoverable hardware error on a single sector.  (Is this incorrect?)

On Tue, May 31, 2016 at 11:07 PM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
> Yes, that is incorrect. If your timeouts are configured correctly the drive
> will report an uncorrectable error up the stack. MD will try to get the data
> from elsewhere and it will try to re-write the bad sector with the
> reconstructed data.

Ah ha.  OK.  That makes a lot more sense.  Thanks.  And I *know* I had
bad timeouts on consumer drives before I replaced this drive.

> I do daily short SMART tests, weekly long SMART tests and monthly "check"
> scrubs of the RAID(s). I'm not saying it's best practice, but I've had
> several drives turn up SMART failures and managed to address those before it
> became an issue on any of the arrays.

As far as SMART, I'm running with the default Fedora behavior in that
area.  I don't believe it does any automatic tests, unless the default
logwatch behavior does SMART tests.  I'll add this to my "todo" list.
Thanks.

              Eddie
