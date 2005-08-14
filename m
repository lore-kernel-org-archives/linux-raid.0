From: djani22@dynamicweb.hu
Subject: Re: Found a new bug!
Date: Mon, 15 Aug 2005 00:38:51 +0200
Message-ID: <03e501c5a120$f3a79a00$0400a8c0@LocalHost>
References: <20050717182650.24540.patches@notabene><E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au><009001c58ac8$9ab25d40$0400a8c0@LocalHost> <17114.55335.687696.686786@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list, Neil!

Is there something news with the 2TB raid-input problem?
Sooner or later, I will need to join two 8TB array to one big 16TB. :-)

Thanks, 

Janos


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
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
