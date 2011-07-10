From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: dm-crypt over raid6 unreadable after crash
Date: Sun, 10 Jul 2011 14:03:50 +0200
Message-ID: <20110710120350.GA30568@apartia.fr>
References: <20110706161228.GA1491@apartia.fr>
 <4E1494BB.9060101@turmel.org>
 <20110707090540.GA7288@apartia.fr>
 <4E15A980.3060508@turmel.org>
 <20110707130917.GA18812@apartia.fr>
 <4E15B576.9040004@turmel.org>
 <20110708054045.GA28420@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110708054045.GA28420@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 08, 2011 at 07:40:45AM +0200, Luca Berra wrote:
> >This is important.  When I computed the sector count for the linear mapping, I just took 2048 off the end.  You may want to select a sector count that aligns the endpoint.
> but the xfs sb should be at sector 0

So what should I change to the dmsetup command to make it work?
