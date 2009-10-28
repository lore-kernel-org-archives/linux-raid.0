From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: md software raid
Date: Wed, 28 Oct 2009 15:03:06 +1300
Message-ID: <4AE7A65A.2030502@sauce.co.nz>
References: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com> 	<20091028005303577.NTSS9287@cdptpa-omta02.mail.rr.com> <70ed7c3e0910271758r3f10b79fw99375299ed721f1e@mail.gmail.com> 	<4AE7955B.3020501@sauce.co.nz> <70ed7c3e0910271810t368f3081g3db4411ab073b531@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0910271810t368f3081g3db4411ab073b531@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Majed B. wrote:
> Thank you Richard for the update!
> 
> Though with the recent performance drops of XFS on 2.6.3x kernels, and
> the fact that the XFS patches are fairly new (and probably buggy), I'd
> rather stay away from XFS for a while and look into other possible
> options. If any...

No, as I mentioned earlier, the original poster of the thread of the 
"reduced write performance on late kernels", later posted that the 
slowdown occured on ext filesystems as well and indeed if you search the 
archive back a week or so, you will find he has bisected the patchs that 
have caused this regression.

Regards,

Richard
