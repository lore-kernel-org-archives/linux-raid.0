From: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH md ] Better handling of readerrors with raid5.
Date: Wed, 21 Sep 2005 18:07:24 +0300
Message-ID: <200509211807.24194.a1426z@gawab.com>
References: <20050916125754.11044.patches@notabene> <62b0912f050920171550edcab1@mail.gmail.com> <17201.9323.915024.189868@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17201.9323.915024.189868@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> I'm nearly ready to give away a patch which does a background parity
> check - it reads all blocks and checks parity, and reports the error
> count etc.  Running such a thing every night (or every week) is
> probably a good idea in some situations, but really needs the
> fix-read-errors patch.

I love it!

Thanks!

--
Al

