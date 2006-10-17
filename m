From: "Andrew Moise" <chops@demiurgestudios.com>
Subject: Re: PERC5 - MegaRaid-SAS problems..
Date: Tue, 17 Oct 2006 18:19:58 -0400
Message-ID: <df1ef2450610171519r6ee6da3dv3fb2dd479d0431a6@mail.gmail.com>
References: <Pine.LNX.4.56.0610121246400.11816@lion.drogon.net>
	 <Pine.LNX.4.56.0610171138400.4600@lion.drogon.net>
	 <df1ef2450610171058i15ad6b47kb8579fc3f1a7e8ee@mail.gmail.com>
	 <Pine.LNX.4.56.0610171944530.5144@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0610171944530.5144@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-poweredge@dell.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/17/06, Gordon Henderson <gordon@drogon.net> wrote:
> I have had problems with XFS, but that was about 2 years ago, so things
> might have improved by then.

  Well, filling some random files with zeroes because of an unclean
shutdown is still defined as "correct" behavior in XFS.  That hasn't
changed that I've heard of.  Why they haven't implemented something
akin to "data=ordered" is a mystery to me.
  I guess I'm begging to start a filesystem flamewar at this point :-).

> After your comment about ext3 max FS size, I had a bit of a oo-er
> situation so had to do a bit of looking to make sure I was OK, and it
> seems that 16TB is the current limit, so OK there for a while, at least...
> (/usr/src/linux/documentation/filesystems/ext2.txt)

  Aah, great news.  Different sources differ on what the max size is,
so I was pessimistically assuming it might be as low as 2TB.  Thanks.
