From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: md software raid
Date: Wed, 28 Oct 2009 17:06:46 +0100
Message-ID: <200910281706.46264.bernd.schubert@fastmail.fm>
References: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com> <4AE76D98.7000003@redhat.com> <4AE85E71.30807@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE85E71.30807@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Ric Wheeler <rwheeler@redhat.com>, Richard Scobie <richard@sauce.co.nz>, "Majed B." <majedb@gmail.com>, Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <esandeen@redhat.com>, Dave Chinner <david@fromorbit.com>
List-Id: linux-raid.ids

On Wednesday 28 October 2009, Eric Sandeen wrote:

> xfs_check is more or less deprecated; it is known to have large memory
> requirements, and xfs_repair is the tool to use.

What about adding a warning message to it then? I guess most people don't 
check list archives first before using it. 


Thanks,
Bernd
