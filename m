From: Joel <jdy@cryregarder.com>
Subject: Re: Some md/mdadm bugs
Date: Mon, 6 Feb 2012 16:59:39 +0000 (UTC)
Message-ID: <loom.20120206T175724-186@post.gmane.org>
References: <4F2ADF45.4040103@shiftmail.org> <20120203081717.195bfec8@notabene.brown> <4F2B1519.5010500@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Asdo <asdo <at> shiftmail.org> writes:

> Neil say:
> > ACTION=="remove", RUN+="/sbin/mdadm -If $name"
> >
> > in /etc/udev/rules.d/something.rules
> >
> > will make that happen.
> 
> Oh great!
> 
> Will use that.
> 
> --incremental --fail ! I would never have thought of combining those.

I don't think the -If is --incremental --fail.  It is --incremental --force. 
Doesn't incremental automagically add a device if it is new and remove a device
if it is old?

Joel

