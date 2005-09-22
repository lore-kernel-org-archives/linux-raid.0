From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Thu, 22 Sep 2005 03:00:09 +0200
Message-ID: <20050922010009.GA8750@uio.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au> <20050921192326.GA30405@uio.no> <20050922001421.GA2205@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050922001421.GA2205@uio.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 22, 2005 at 02:14:21AM +0200, Steinar H. Gunderson wrote:
> It seems to survive even under quite heavy load now (but of course, restripe
> performance suffers badly when doing heavy stuff on the volume :-) ). Too
> soon to say if there are problems still, of course.

Nopes, it's still corrupting if I'm doing heavy I/O against it while
expanding, even after two more patches of the same type. I haven't seen the
uninterruptible sleep problem in this round of tests, but I won't say for 
sure that it went away either. :-)

(Yes, I'm replying to myself _again_ :-) )

/* Steinar */
-- 
Homepage: http://www.sesse.net/
