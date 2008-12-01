From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm: suppress sending emails on events
Date: Mon, 1 Dec 2008 20:31:28 +1100 (EST)
Message-ID: <a1f938f34c18d51c81491e09c0b53487.squirrel@neil.brown.name>
References: <200812011017.22207.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200812011017.22207.wilhelm.meier@fh-kl.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, December 1, 2008 8:17 pm, Wilhelm Meier wrote:
> Is there a way to suppress sending the default emails from mdadm in
> the case an event occurs. I want the --program to be the only one
> sending emails ;-)
>

Simply don't set an email address for mail to go to.  Then nothing
will be set.

NeilBrown

