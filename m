From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.2.1 doesn't compile with gcc 4.6.0
Date: Wed, 27 Apr 2011 10:00:27 +1000
Message-ID: <20110427100027.11c1161b@notabene.brown>
References: <201104260900.20791.t.powa@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201104260900.20791.t.powa@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias Powalowski <t.powa@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 26 Apr 2011 09:00:17 +0200 Tobias Powalowski <t.powa@gmx.de> wrote:

> Hi guys,
> mdadm.c:106:6: error: variable 'auto_update_home' set but not used [-
> Werror=unused-but-set-variable]
> 
> 
> any help would be much appreciated.
> thanks
> greetings
> tpowa

Thanks for the report.

If you build with
  make CWFLAGS=

it will not treat warnings as errors and it should successfully compile.

I have committed a fix:

http://neil.brown.name/git?p=mdadm;a=commitdiff;h=7e90264df5060cd308ce56206ec7dfa29e2aa041

Thanks,
NeilBrown
