From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Fri, 7 Oct 2005 16:13:16 +0200
Message-ID: <20051007141316.GA16113@uio.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au> <20050920153622.GA14287@uio.no> <17202.55529.310871.877019@cse.unsw.edu.au> <20050924014412.GA19832@uio.no> <17221.59105.846162.739316@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17221.59105.846162.739316@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 07, 2005 at 01:09:21PM +1000, Neil Brown wrote:
> However it is usually easier to read a whole patch - reading a patch
> that removes bits of a previous patch, and depends on other bits of
> it, requires holding too much in one's brain at once.  If you could
> possibly send a complete patch against a recent release kernel, it
> would make review a lot easier.

Mm, OK.

>> I'm unsure how much this actually buys us (there's a slight reduction in
>> complexity, but I fear that will go up again once I implement it for read
>> stripes as well),
> I think it buys us a lot.  It means we can wait for stripes to become
> free instead of spinning around hoping they will come free soon.

Well, I've been doing printk-debugging on this, and it's actually a quite
rare case (even with heavy I/O) that it's starved for stripes.

> Currently the patch looks mostly good, but there are a couple of
> structural changes that I think it needs as I mentioned previously.
> Once these are in place, I can review the code more closely and look
> for races and other subtle semantic issues.

Mm. I'm still a bit ambivalent about a rewrite; I need something working in
about exactly a month (when we're going to restripe our backup server) and a
rewrite would no doubt destabilize it all for quite a while. My test server
is currently broken after I tried to get in a kdb-enabled kernel; grub
conveniently broke at about the same time :-) I'm not sure how much time I
can dedicate to this ATM either.

I definitely agree moving code into sync_request would result in a better
overall model, though, with less overhead in the usual (non-restripe) paths.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
