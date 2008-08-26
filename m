From: "rae l" <crquan@gmail.com>
Subject: from raid456 patch, about the tiotest tool
Date: Wed, 27 Aug 2008 02:03:39 +0800
Message-ID: <91b13c310808261103y326d57e8q737647b88d925daa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, Dan:
  I've known your md(raid456) patch just before v2.6.26,

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8b3e6cdc53b7f29f7026955d6cb6902a49322a15

your md patch referred to tiobench, which is the multi-thread
benchmark tool, I'm interested on this tool and I found I ran it
differently with your results, so I want to know more about it,

from its home page, it only released v0.3.3 on Mar 2002,

http://sourceforge.net/projects/tiobench/

but from its cvs repository, it has released v0.4.1,

http://tiobench.cvs.sourceforge.net/tiobench/tiobench/

Could you tell me what version of tiobench did you use? I want to see
if that's my configuration fault or I have used wrong program version.

And when using v0.4.1 of tiobench from its cvs repository, I found its
multiple threads random IO statistics code reported wrong results, and
have resolved it by this patch,

http://sourceforge.net/tracker/index.php?func=detail&aid=2047536&group_id=3857&atid=303857

But its upstream seems have not noticed it yet, so I want to if
someone on this mailling-list know tiobench upstream and be able to
take this message?

Thanks.

--
Denis Cheng
