From: Chris Osicki <osk@admin.swisscom-mobile.ch>
Subject: Re: Question: array locking, possible?
Date: Wed, 8 Feb 2006 11:55:49 +0100
Message-ID: <20060208115549.2c771ecb@mwdsp001.swissptt.ch>
References: <20060207185517.7bc96486@mwdsp001.swissptt.ch>
	<43E8F455.2020800@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E8F455.2020800@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I was thinking about it, I have no idea how to do it on Linux if ever possible.
I connect over fibre channel SAN, using QLogic QLA2312 HBAS, if it matters.

Anyone any hints?

Thanks and regards,
Chris

On Tue, 07 Feb 2006 14:26:13 -0500
Paul Clements <paul.clements@steeleye.com> wrote:

> Chris Osicki wrote:
> > The problem now is how to prevent somebody on the other host from
> > accidentally assembling the array. Because the result of doing so would
> > be something from strange to catastrophic ;-)
> > 
> > To rephrase my question, is there any way to make it visible to the
> > other host that the array is up an running on the this host?
> 
> I don't know how the storage boxes are attached to the servers, but you 
> might be able to use SCSI reservations, if the storage supports them.
> 
> --
> Paul
> 
