From: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Subject: Re: mdadm: suppress sending emails on events [solved] (dumb question - sorry)
Date: Mon, 1 Dec 2008 10:28:57 +0100
Message-ID: <200812011028.57906.wilhelm.meier@fh-kl.de>
References: <200812011017.22207.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200812011017.22207.wilhelm.meier@fh-kl.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Montag 01 Dezember 2008 schrieb Wilhelm Meier:
> Is there a way to suppress sending the default emails from mdadm in
> the case an event occurs. I want the --program to be the only one
> sending emails ;-)

Sorry, just leaving out the MAIL option does the trick.

-- 
Wilhelm
