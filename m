From: djani22@dynamicweb.hu
Subject: Re: Found a new bug!
Date: Mon, 18 Jul 2005 00:31:13 +0200
Message-ID: <013701c58b1f$3e6e7300$0400a8c0@LocalHost>
References: <20050717182650.24540.patches@notabene><E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au><009001c58ac8$9ab25d40$0400a8c0@LocalHost> <17114.55335.687696.686786@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message -----
From: "Neil Brown" <neilb@cse.unsw.edu.au>
To: <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Monday, July 18, 2005 12:13 AM
Subject: Re: Found a new bug!


> On Sunday July 17, djani22@dynamicweb.hu wrote:
> > Hi all!
> >
> > I think I found a new bug in the kernel ! (or mdadm?)
>
> Yes.  With the current code you cannot have components of a 'linear'
> which are larger than 2^32 sectors.  I'll try to put together a fix
> for this in the next day or so.
>
> NeilBrown

Thanks for help!

Another one question:

I did'nt find an usable way for me, but my system must start anyway....

I hava created the XFS directly to the 8TB raid0 (/dev/md31), and now the
copy is runing...
It is possible in the future to convert it to be a part of the planned
linear array without backup all data?

Thanks.

