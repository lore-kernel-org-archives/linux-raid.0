From: Neil Brown <neilb@suse.de>
Subject: Re: [Xen-devel] Re: Weird Issue with raid 5+0
Date: Wed, 10 Mar 2010 06:42:30 +1100
Message-ID: <20100310064230.2ebc8ed6@notabene.brown>
References: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>
	<20100221164805.5bdc2d60@notabene.brown>
	<31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>
	<20100221191640.39b68b01@notabene.brown>
	<20100308165021.6529fe6d@notabene.brown>
	<31e44a111003080735t4ddf7c63uaa517ad6522cca67@mail.gmail.com>
	<20100308172915.GE4568@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100308172915.GE4568@phenom.dumpdata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: chris <tknchris@gmail.com>, Xen-Devel List <xen-devel@lists.xensource.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 8 Mar 2010 12:29:15 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> The patch at http://marc.info/?l=linux-raid&m=126802743419044&w=2 looks
> to be quite safe so it should be easy for you to pull it and apply it to
> your sources?
> 
> Neil, any idea when this patch might land in Greg KH's tree (2.6.32) or
> upstream?
> 

Not really.
It was observer on the dm-devel list that the patch isn't quite perfect.
There are possible, though rare, cases where it is not sufficient.  So I
suspect it will be revised and re-submitted.  So it might go upstream in a
week or so, and then into -stable in due course, but it is really up to the
dm developers.

NeilBrown
