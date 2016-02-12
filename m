From: "John Stoffel" <john@stoffel.org>
Subject: Re: md raid5 on top of dmcrypt, or dmcrypt on top of md raid5?
Date: Fri, 12 Feb 2016 14:57:02 -0500
Message-ID: <22206.14606.181359.676881@quad.stoffel.home>
References: <20160211162959.GG13969@merlins.org>
	<alpine.DEB.2.02.1602121020570.11524@uplift.swm.pp.se>
	<wrfja8n62e0c.fsf@redhat.com>
	<20160212190700.GQ13969@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160212190700.GQ13969@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Marc,

Did you look into lvcache instead of bcache?  The problem with bcache
is that you can't (as I understand it) remove it from a live volume,
while you can with lvache.

John
