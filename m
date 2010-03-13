From: Neil Brown <neilb@suse.de>
Subject: Re: Resize RAID-0?
Date: Sat, 13 Mar 2010 11:50:02 +1100
Message-ID: <20100313115002.3f085832@notabene.brown>
References: <23986fd91003111939w102813c6r8d1b51a387784a71@mail.gmail.com>
	<73e903671003120336m36718a31m1c4ce760c42dbc75@mail.gmail.com>
	<23986fd91003120903s77c36c37lb3f3f770c9457091@mail.gmail.com>
	<23986fd91003121609o19b9fd6s22e3711c9d9c8455@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23986fd91003121609o19b9fd6s22e3711c9d9c8455@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 12 Mar 2010 16:09:43 -0800
"Patrick J. LoPresti" <lopresti@gmail.com> wrote:

> Addendum (for the archives).
> 
> EVMS claims to support this:
> 
> http://evms.sourceforge.net/user_guide/#resizeraid0

Just for clarification, that is an off-line non-interruptible (better have a
UPS) resize.

There is a command line tool to do this:

  http://unthought.net/raidreconf/

however I wouldn't recommend it, because if anything goes wrong in the middle,
you lose your data.

NeilBrown
