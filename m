From: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Tue, 20 Sep 2005 21:54:13 +0300
Message-ID: <200509202154.13468.a1426z@gawab.com>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17200.9302.242957.23189@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday September 20, sgunderson@bigfoot.com wrote:
> > - It's RAID-5 only; I don't really use RAID-0, and RAID-6 would probably
> > be more complex.
>
> I doubt raid6 would be much more difficult.  However it is definitely
> best to get it working well in raid5 first.
> I'd never thought of doing raid0, but I cannot now think of a good
> reason not to.....

Always generalize the code, which forces modularization, which implies 
simplicity, structure, and scalability, thus gaining reliability and 
performance.

Thanks, and keep up the good work!

--
Al

