From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Fri, 23 Sep 2005 14:50:53 +0200
Message-ID: <20050923125053.GA19660@uio.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au> <20050920153622.GA14287@uio.no> <17202.55529.310871.877019@cse.unsw.edu.au> <20050922163220.GA27401@uio.no> <17203.50134.95668.144452@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17203.50134.95668.144452@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 23, 2005 at 10:59:02AM +0200, Neil Brown wrote:
>> Hm. make_request is never called from the sync code, is it? My understanding
>> was that make_request was called whenever userspace wanted to read/write
>> something, and only then.
> Sorry, I meant sync_request.

Hm, that makes a lot more sense :-) I'll have a look at it and see if I can
get it to work in a sane way.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
