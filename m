From: David Greaves <david@dgreaves.com>
Subject: Re: Proposed enhancement to mdadm:  Allow "--write-behind=" to be
 done	in grow mode.
Date: Tue, 03 Jul 2007 15:03:10 +0100
Message-ID: <468A571E.7040304@dgreaves.com>
References: <1183038727.3792.9.camel@sibyl.beware.dropbear.id.au>	 <1183130939.4544.6.camel@sibyl.beware.dropbear.id.au> <1183468329.395.59.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1183468329.395.59.camel@sibyl.beware.dropbear.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Dall <ian@beware.dropbear.id.au>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ian Dall wrote:
> There doesn't seem to be any designated place to send bug reports and
> feature requests to mdadm, so I hope I am doing the right thing by
> sending it here.
> 
> I have a small patch to mdamd which allows the write-behind amount to be
> set a array grow time (instead of currently only at grow or create
> time). I have tested this fairly extensively on some arrays built out of
> loop back devices, and once on a real live array. I haven't lot any data
> and it seems to work OK, though it is possible I am missing something.

Sounds like a useful feature...

Did you test the bitmap cases you mentioned?

David
