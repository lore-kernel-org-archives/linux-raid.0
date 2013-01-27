From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 00:11:01 +0100
Message-ID: <20130127231101.75A972033CC@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130127200557.GA10960@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20130127200557.GA10960@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Robin Hill,

In message <20130127200557.GA10960@cthulhu.home.robinhill.me.uk> you wrote:
> 
> Is this after having run a check, or just after boot? I've seen some odd
> numbers at times, but they've gone away after running a check
> (presumably something not being initialised).

The non-zero mismatch_cnt was reported by a check, and after that I
looked at the state of the array.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
People are always a lot more complicated than you  think.  It's  very
important to remember that.             - Terry Pratchett, _Truckers_
