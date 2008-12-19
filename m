From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: weird issues with raid1
Date: Thu, 18 Dec 2008 20:15:51 -0600
Message-ID: <cccedfc60812181815oa63b526tb51c3bee558fbdf@mail.gmail.com>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	 <18758.52536.345145.238926@notabene.brown>
	 <cccedfc60812151347j659112c5na3aa8cd0eb044669@mail.gmail.com>
	 <18759.678.74091.236787@notabene.brown>
	 <18761.54425.725696.255055@notabene.brown>
	 <cccedfc60812172050h58697665y975a18550842aebb@mail.gmail.com>
	 <cccedfc60812172055n58181ad4lcdff8f172c6a496c@mail.gmail.com>
	 <18761.56537.935250.561921@notabene.brown>
	 <cccedfc60812172147q240466a8w53c5bd2540edf6a4@mail.gmail.com>
	 <18761.60380.938542.26851@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18761.60380.938542.26851@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> jnelson@turnip:~/kernels> (cd linux-2.6 && git diff
>> a0da84f35b25875870270d16b6eccda4884d61a7
>> a0da84f35b25875870270d16b6eccda4884d61a7^ ) > d.diff
>
> This is requesting the diff between a given version, and the previous
> version.  So it will be a reversed diff.

*sigh*

> i.e. these two lines are *added* by the patch.
> I usually use e.g.
>   git log -p a0da84f35b25875870270d16b6eccda4884d61a7
> to look at diffs.  Less room for confusion. (or gitk).

I will remember that one!

> and as those two lines are not present here, the patch as not been
> applied.

I'll apply and get back to you. My raid rebuilt 3 times today, quite
possibly because of this.

Obviously, I'm abusing the code in ways it was not intended to be
used. Sometimes that's good for finding corner-case-y kinds of issues,
though.

Thanks again for your patience.

-- 
Jon
