From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 11:26:49 +0200
Message-ID: <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>
References: <449AEB7C.6040108@cjx.com> <op.tblclqd3cigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.tblclqd3cigqcu@apollo13>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Chris Allen <chris@cjx.com>, PFC <lists@peufeu.com>
List-Id: linux-raid.ids

2006/6/23, PFC <lists@peufeu.com>:
>
>         - XFS is faster and fragments less, but make sure you have a good UPS
Why a good UPS ? XFS has a good strong journal, I never had an issue
with it yet... And believe me, I did have some dirty things happening
here...

>         - ReiserFS 3.6 is mature and fast, too, you might consider it
>         - ext3 is slow if you have many files in one directory, but has more
> mature tools (resize, recovery etc)
XFS tools are kind of mature also. Online grow, dump, ...

>
>         I'd go with XFS or Reiser.
I'd go with XFS. But I may be kind of fanatic...
