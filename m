From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Found a new bug!
Date: Mon, 18 Jul 2005 08:13:59 +1000
Message-ID: <17114.55335.687696.686786@cse.unsw.edu.au>
References: <20050717182650.24540.patches@notabene>
	<E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au>
	<009001c58ac8$9ab25d40$0400a8c0@LocalHost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from djani22@dynamicweb.hu on Sunday July 17
Sender: linux-raid-owner@vger.kernel.org
To: djani22@dynamicweb.hu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 17, djani22@dynamicweb.hu wrote:
> Hi all!
> 
> I think I found a new bug in the kernel ! (or mdadm?)

Yes.  With the current code you cannot have components of a 'linear'
which are larger than 2^32 sectors.  I'll try to put together a fix
for this in the next day or so.

NeilBrown
