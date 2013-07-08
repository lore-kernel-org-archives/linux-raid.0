From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 03/27] DDF: load_ddf_headers: use secondary header as
 fallback
Date: Mon, 08 Jul 2013 22:56:29 +0200
Message-ID: <51DB277D.5040100@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>	<1372883287-8859-4-git-send-email-mwilck@arcor.de> <20130708154322.4ff65e03@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130708154322.4ff65e03@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/08/2013 07:43 AM, NeilBrown wrote:

> Should that "|| super->active == NULL" test go at the beginning of the 'if'
> rather than the set?  Currently it comparing sequence numbers between the
> successfully read secondary and the (possibly) badly read primary.

That makes certainly sense. Thanks for spotting it.

Martin

