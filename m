From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: small patches to mdadm
Date: Mon, 6 Sep 2004 14:47:48 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16699.60404.552366.954950@cse.unsw.edu.au>
References: <20040825072235.GB5851@percy.comedia.it>
	<16686.39118.516906.365004@cse.unsw.edu.au>
	<20040830130904.GA1763@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Monday August 30
To: Luca Berra <bluca@comedia.it>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday August 30, bluca@comedia.it wrote:
> On Fri, Aug 27, 2004 at 12:13:34PM +1000, Neil Brown wrote:
> >They'll both be in the next release.
> thanks a lot!
> here is another patch for mdassemble.
> 1) add raid6 and raid10
> 2) add support for the auto=... option.
> the auto= can be disabled in the Makefile, allowing users to save about
> 5k (on x86).

Thanks.  
I redid the auto= stuff.  I moved mddev_open into a separate file.

It'll be in the next mdadm.

NeilBrown
