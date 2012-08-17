From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: md: raid 10 supports TRIM
Date: Fri, 17 Aug 2012 10:41:40 +0200
Message-ID: <502E03C4.5000607@computer.org>
References: <20120816110237.GA4709@elgon.mountain> <502DAEB3.6080302@fusionio.com> <20120817040015.GA8644@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120817040015.GA8644@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, dan.carpenter@oracle.com, neilb@suse.de
List-Id: linux-raid.ids

On 08/17/2012 06:00 AM, Shaohua Li wrote:
> Thanks! Neil, this is the updated patch. If you prefer a fix against original
> patch, please let me know. 

I rather suspect that Neil has already applied the original version of
your patch, that Dan then ran his static checker on Neil's tree (or
perhaps on linux-next?) and found this problem.

If so, Neil will need an incremental fix from you, rather than a fix
that's incorporated into the patch that introduced the problem.

HTH, Jan

