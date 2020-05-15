From: Wolfgang Denk <wd@denx.de>
Subject: Re: raid6check extremely slow ?
Date: Fri, 15 May 2020 10:08:08 +0200
Message-ID: <20200515080808.E637B240E1A@gemini.denx.de>
References: <20200510120725.20947240E1A@gemini.denx.de> <1999694976.3317399.1589476824607.JavaMail.zimbra@karlsbakk.net> <20200514182041.CDF1F240E1A@gemini.denx.de> <1430936688.3381175.1589485881380.JavaMail.zimbra@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1430936688.3381175.1589485881380.JavaMail.zimbra@karlsbakk.net>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Roy Sigurd Karlsbakk,

In message <1430936688.3381175.1589485881380.JavaMail.zimbra@karlsbakk.net> you wrote:
> what?

You asked: "Try checking with iostat -x to see if one disk is
performing worse than the other ones."

The output of "iostat -x" which I posted shows clearly that all disk
behave very much the same - there are just minimal statistic
fluctuations, but agail equally distributed over all 8 disks.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
I used to be indecisive, now I'm not sure.
