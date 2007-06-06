From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Customize the error emails of  `mdadm --monitor`
Date: Wed, 6 Jun 2007 22:49:26 +0200
Message-ID: <20070606204925.GA23777@boogie.lpds.sztaki.hu>
References: <46619542.6010507@rabbit.us> <46669B20.6030706@rabbit.us> <20070606121121.GA23486@teal.hq.k1024.org> <4666A743.3050900@rabbit.us> <20070606141035.GA9404@boogie.lpds.sztaki.hu> <4666C39F.6040504@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4666C39F.6040504@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 06, 2007 at 04:24:31PM +0200, Peter Rabbitson wrote:

> So I was asking if the component _number_, which is unique to a specific 
> device regardless of the assembly mechanism, can be reported in case of a 
> failure.

So you need to write an event-handling script and pass it to mdadm
(--program). In the script you can walk sysfs and/or call the
appropriate helper programs to extract all the information you need and
format it in the way you want. For example, if you want the slot number
of a failed disk, you can get it from /sys/block/$2/md/dev-$3/slot
(according to the manpage, not tested).

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
