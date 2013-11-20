From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Triple parity and beyond
Date: Wed, 20 Nov 2013 13:28:28 -0800
Message-ID: <528D297C.6010707@zytor.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <CAGKKSfUGLzeLfab0uJTGV=UELxEH+mB3K4VbDouHxzmc+xuZ2A@mail.gmail.com> <528D0913.1070604@zytor.com> <BD8F4758-37F1-44FC-8FB6-0F798FE626DF@cs.utk.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BD8F4758-37F1-44FC-8FB6-0F798FE626DF@cs.utk.edu>
Sender: linux-btrfs-owner@vger.kernel.org
To: James Plank <plank@cs.utk.edu>
Cc: Andrea Mazzoleni <amadvance@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Brown <david.brown@hesbynett.no>, David Smith <creamyfish@gmail.com>
List-Id: linux-raid.ids

On 11/20/2013 12:30 PM, James Plank wrote:
> Peter, I think I understand it differently.  Concrete example in GF(256) for k=6, m=4:
> 
> First, create a 3 by 6 cauchy matrix, using x_i = 2^-i, and y_i = 0 for i=0, and y_i = 2^i for other i.  In this case:   x = { 1, 142, 71, 173, 216, 108 }  y = { 0, 2, 4).  The cauchy matrix is:

Sorry, I took xi and yj to mean a constant x multiplied with i and a
constant y multiplied with j, rather than x_i and y_j.

	-hpa

