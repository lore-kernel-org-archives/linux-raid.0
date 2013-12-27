From: keld@keldix.com
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Fri, 27 Dec 2013 16:49:52 +0100
Message-ID: <20131227154952.GA6539@www5.open-std.org>
References: <52BD8EDD.10809@assyoma.it> <20131227151927.GA4003@www5.open-std.org> <52BD9B4F.3000509@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52BD9B4F.3000509@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 27, 2013 at 04:22:55PM +0100, Gionatan Danti wrote:
> 
> >On Fri, Dec 27, 2013 at 03:29:49PM +0100, Gionatan Danti wrote:
> >The wikipedia description is what you get for new arrays with newer
> >kernels, while the suse documentation is what you will get with older 
> >kernels.
> >The wikipedia layout was made because there are better chances of recovery,
> >Chances went from 1/3 to 2/3 with eg 4 drives, when 2 drives were failing.
> >
> >I would say that the Suse description is just not updated.
> >
> >Best regards
> >Keld
> >
> 
> Interesting. Two question:
> 1) from which kernel the layout is the one depicted by Wikipedia?
> 2) it is possible, using mdadm, check what "far" layout is in use?

I cannot answer that. Neil Brown should know.

Best regards
Keld
