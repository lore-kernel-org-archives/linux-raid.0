From: Bryan O'Sullivan <bos@serpentine.com>
Subject: Re: [PATCH] klibc update
Date: Tue, 16 Mar 2004 12:11:05 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1079467865.14516.56.camel@serpentine.pathscale.com>
References: <4056B0DB.9020008@pobox.com>
	 <20040316005229.53e08c0c.akpm@osdl.org> <20040316153719.GA13723@kroah.com>
	 <20040316111026.6729e153.akpm@osdl.org> <40575279.7040408@pobox.com>
	 <20040316192458.GB21172@kroah.com> <40575631.1080006@pobox.com>
	 <20040316115340.361f2a14.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040316115340.361f2a14.akpm@osdl.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org, viro@parcelfarce.linux.theplanet.co.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2004-03-16 at 11:53, Andrew Morton wrote:

> It would be rather handy if someone could maintain the definitive tree for
> this work for a while, until we linusify it.

I'll spend a bit of time in the next few days bringing it up to date
w.r.t the current kernel and klibc trees.

> I don't have a feeling for its stability/readiness/desirability/anthingelse
> at this stage.  How mergeable is it?

Not very.  klibc itself works OK, and the in-tree tools that use it work
OK, but they get very few "pick ourselves up off the ground and do a
complete boot" test cycles.

It's definitely 2.7 material.

	<b

