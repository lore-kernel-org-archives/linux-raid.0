From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: optimal IO scheduler choice?
Date: Thu, 13 Dec 2007 12:36:57 +0100
Message-ID: <20071213113657.GC24747@boogie.lpds.sztaki.hu>
References: <20071213075217.GA8241@apartia.fr> <Pine.LNX.4.64.0712130621490.2285@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712130621490.2285@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 13, 2007 at 06:24:15AM -0500, Justin Piszcz wrote:

> Sequential:
> Output of CFQ: (horrid): 311,683 KiB/s
>  Output of AS: 443,103 KiB/s

OTOH AS had worse latencies than CFQ AFAIR (it was quite some time ago I
last experimented). So it depends on what do you want to optimize for.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
