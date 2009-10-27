From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: md software raid
Date: Tue, 27 Oct 2009 14:15:14 -0700
Message-ID: <7bc80d500910271415y33413ea9x53190bea9595c051@mail.gmail.com>
References: <26023091.post@talk.nabble.com>
	 <20091023093820.GA7613@cthulhu.home.robinhill.me.uk>
	 <000601ca56ee$f7a4d360$e6ee7a20$@com> <4AE75D87.60708@tmr.com>
	 <4AE75E26.1080303@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE75E26.1080303@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Bill Davidsen <davidsen@tmr.com>, Ian Docherty <idiandocherty@googlemail.com>, Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 27, 2009 at 1:55 PM, Richard Scobie <richard@sauce.co.nz> wrote:
> Bill Davidsen wrote:
>
>
>> That's certainly a valid point, if you are stuck using xfs by preference
>> or requirement. I have seen claims that 2.6.32 will be better, but I have no
>> intention of testing it, having parted company with xfs a while ago.
>
> The OP of the thread metioned, was able to duplicate the slowdown using
> ext3, so it probably has nothing to do with XFS.

It probably has to do with the added writes...if they can try it with
ext2 (yeah, yeah, yuck) they might see something.

Especially if this is raid 5 or 6.

cc

-- 
Chris Chen <muffaleta@gmail.com>
"The fact that yours is better than anyone else's
is not a guarantee that it's any good."
-- Seen on a wall
