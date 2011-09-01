From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: raid array with 3T disks and GPT partition
Date: Thu, 1 Sep 2011 17:57:26 +0200
Message-ID: <20110901155726.GA3195@apartia.fr>
References: <20110901154759.GA32649@apartia.fr>
 <4E5FAA5E.80007@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E5FAA5E.80007@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 01, 2011 at 05:53:02PM +0200, Pim Zandbergen wrote:
> On 09/01/2011 05:47 PM, Louis-David Mitterrand wrote:
> >
> >Now how do I make sure that these partitions have the correct "raid
> >autodetect" (fd) id? Is it even still needed? I didn't find any way to
> >set that flag in (g)parted.
> >
> I used gdisk and entered FD00

Didn't know this tool, thanks.

So (g)parted is not appropriate for creating raid-autodetect partitions?
