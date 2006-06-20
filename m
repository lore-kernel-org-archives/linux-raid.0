From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: IBM xSeries stop responding during RAID1 reconstruction
Date: Tue, 20 Jun 2006 15:27:53 +0200
Message-ID: <20060620132753.GI22404@boogie.lpds.sztaki.hu>
References: <20060614085354.GA18106@rigacci.org> <44902F41.8030300@rcn.com> <20060619150556.GQ11429@boogie.lpds.sztaki.hu> <20060620130859.GA15394@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060620130859.GA15394@rigacci.org>
Sender: linux-raid-owner@vger.kernel.org
To: Niccolo Rigacci <niccolo@rigacci.org>
Cc: linux-raid@vger.kernel.org, Bill Cizek <cizek@rcn.com>
List-Id: linux-raid.ids

On Tue, Jun 20, 2006 at 03:08:59PM +0200, Niccolo Rigacci wrote:

> Do you know if it is possible to switch the scheduler at runtime?

echo cfq > /sys/block/<disk>/queue/scheduler

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences,
     Laboratory of Parallel and Distributed Systems
     Address   : H-1132 Budapest Victor Hugo u. 18-22. Hungary
     Phone/Fax : +36 1 329-78-64 (secretary)
     W3        : http://www.lpds.sztaki.hu
     ---------------------------------------------------------
