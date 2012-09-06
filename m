From: John Drescher <drescherjm@gmail.com>
Subject: Re: Safe disk replace
Date: Thu, 6 Sep 2012 08:59:56 -0400
Message-ID: <CAEhu1-7eJq1-Z0yW=HjqKyYaGFC+Dm+4JT0CzKCobanBGAWT-A@mail.gmail.com>
References: <20120904041447.GB14445@onthe.net.au>
	<5045D7D9.9000108@hesbynett.no>
	<alpine.DEB.2.00.1209041423250.13902@uplift.swm.pp.se>
	<20120904153342.GA26999@cthulhu.home.robinhill.me.uk>
	<CAEhu1-6oNLaPuoh-aXtrFsnmPZ2fMGVaQSbtQp7Wkx-sf8MfDg@mail.gmail.com>
	<CAEhu1-6+PQr_UG6NLTgXcWgYJYfpp5j7EHt5BnfMmWJr=s-i_g@mail.gmail.com>
	<20120905203203.GA4391@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120905203203.GA4391@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The problem's actually at the point it finishes the recovery. When it
> fails the replaced disk, it treats it as a failure of an in-array disk.
> You get the failure email and the array shows as degraded, even though
> it has the full number of working devices. Your 12/11 would have shown
> even before you started doing the second replacement. It doesn't seem to
> cause any problems in use though, and it gets corrected after a reboot.
>

Thanks. You are correct. It did show 12/11 before the replacement
happened and even after it finished.

John
