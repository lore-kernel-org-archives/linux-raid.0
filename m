From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Mon, 8 Jan 2007 14:38:53 +0100
Message-ID: <20070108133853.GA17906@apartia.fr>
References: <Pine.GSO.4.53.0701060014080.5898@compserv1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.53.0701060014080.5898@compserv1>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 06, 2007 at 12:17:36AM -0500, Chaitanya Patti wrote:
> 
> > We are in the process of porting RAIF to 2.6.19 right now.  Should be done
> > in early January.  The trick is that we are trying to keep the same source
> > good for a wide range of kernel versions.  In fact, not too long ago we
> > even were able to compile it for 2.4.24!
> >
> > Nikolai.
> 
> We now have RAIF for the 2.6.19 kernel available at:
> 
> ftp://ftp.fsl.cs.sunysb.edu/pub/raif/raif-1.1.tar.gz
> 
> This version is more stable but there are for sure still some remaining
> bugs and we very much appreciate your feedback.

Can RAIF be compared in functionality to drbd (when using nfs mounts 
from different hosts) ?
