From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Disk Monitoring
Date: Fri, 30 Jun 2017 14:35:18 +0200
Message-ID: <CAJH6TXg+xf0giY5bC_ug4jm+t88LzHkTVJq_BYeYzxEKedF2OA@mail.gmail.com>
References: <20170628131917.BF1911235B6@gemini.denx.de> <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <2113365.0QvyMCaQ9I@matkor-lenovo> <CAJH6TXiONYigcX1CtQw86ZXUgeOLvzD_+2couNfxSwL9hHj1gA@mail.gmail.com>
 <59550FCB.4090508@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59550FCB.4090508@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-06-29 16:33 GMT+02:00 Wols Lists <antlists@youngman.org.uk>:
> In other words, a patrol check looks for a failing disk. A consistency
> check looks for corrupt data. (A consistency check does a patrol check
> as a side effect, but you might not want to do just that, as it is
> computationally much more expensive. You might want to do a patrol check
> every day, and a consistency check of a weekend.)

Ok, so, if resources are not a problem, someone could only run a
consistency check and totally skip the patrol check. Right ?

What about md reliability? There are many detractors out there.

https://bugzilla.kernel.org/show_bug.cgi?id=99171

One of the most common complaint is the absence of write-back cache,
and if you force a "writeback" you'll risk data loss in case of
unclean shutdown (power failure and so on)
