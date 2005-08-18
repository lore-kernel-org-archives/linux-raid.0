From: djani22@dynamicweb.hu
Subject: Re: perfomance question.
Date: Thu, 18 Aug 2005 17:20:38 +0200
Message-ID: <006f01c5a40b$03c58900$0400a8c0@LocalHost>
References: <20050717182650.24540.patches@notabene><E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au><009001c58ac8$9ab25d40$0400a8c0@LocalHost><17114.55335.687696.686786@cse.unsw.edu.au><03e501c5a120$f3a79a00$0400a8c0@LocalHost><17151.60931.26972.713074@cse.unsw.edu.au><011101c5a187$3bc8cf00$0400a8c0@LocalHost><016001c5a26a$05ad3e40$0400a8c0@LocalHost> <17156.5547.61133.39733@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for trying to help me!

My problem is (looks like) solved.
It was a kernel problem. (I think...)
When I switch to 2.6.13-rc6 (from rc3), the problem is gone!
It is very interesting!

I use SWRAID to distribute equal load to nodes.
(raid0 chunksize 32k)
In my system with 2.6.13-rc3 the "node-3" gets  much more (4x - 5x) read
requests, but dont know why, dont ask! :-)

First I think, the XFS's log is somehow always on 3 rd chunk.
I send this question to XFS-list too, and get this answer:
"The XFS log is always write, except recoverying." - Thats right!

Next idea is to break more the 32k chunks, and send this previous letter to
here.
But I have more problems (network layer-bug) with 13-rc3, and try the newer
kernel, and the problem is gone. :-)
It looks like some network issue.

Thanks

Janos

----- Original Message -----
From: "Neil Brown" <neilb@cse.unsw.edu.au>
To: <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, August 18, 2005 6:59 AM
Subject: Re: perfomance question.


> On Tuesday August 16, djani22@dynamicweb.hu wrote:
> > Hello list,
> >
> > I have performance problem. (again) :-)
> >
> > What chunk size is better in  raid5, and raid0?
> > The lot of small chunks, or some bigger?
>
> This is highly dependant one workload and hardware performance.
> The best thing to do is develop a test that simulates your real
> workload and run it with various stripe sizes, and see which one wins.
>
> I suspect there would be very little gain in going to very small chunk
> sizes (<16k).  Anywhere between there and 1Meg is worth trying.
>
> mdadm uses a default of 64k which is probably not too bad for most
> situations, but I cannot promise it being optimal for any.
>
> Sorry I cannot be more helpful.
>
> Your performance problem may not be chunk-size related.  Maybe
> increasing the readahead (with blockdev) would help...
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

