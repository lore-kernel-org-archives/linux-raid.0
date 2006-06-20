From: Niccolo Rigacci <niccolo@rigacci.org>
Subject: Re: IBM xSeries stop responding during RAID1 reconstruction
Date: Tue, 20 Jun 2006 15:08:59 +0200
Message-ID: <20060620130859.GA15394@rigacci.org>
References: <20060614085354.GA18106@rigacci.org> <44902F41.8030300@rcn.com> <20060619150556.GQ11429@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060619150556.GQ11429@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Bill Cizek <cizek@rcn.com>, Gabor Gombas <gombasg@sztaki.hu>
List-Id: linux-raid.ids

On Mon, Jun 19, 2006 at 05:05:56PM +0200, Gabor Gombas wrote:
> 
> IMHO a much better fix is to use the cfq I/O scheduler during the
> rebuild.

Yes, changing the default I/O to DEFAULT_CFQ solve the problem 
very well, I get over 40 Mb/s resync speed with no lock-up at 
all!

Thank you very much, I think we can elaborate a new FAQ entry.

Do you know if it is possible to switch the scheduler at runtime?

-- 
Niccolo Rigacci
Firenze - Italy

Iraq, missione di pace: 38475 morti - www.iraqbodycount.net
