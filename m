From: Net Llama! <netllama@linux-sxs.org>
Subject: Re: XFS RAID only writing half the time
Date: Tue, 25 Nov 2003 11:01:08 -0500 (EST)
Sender: linux-xfs-bounce@oss.sgi.com
Message-ID: <Pine.LNX.4.55.0311251100390.5879@linux-sxs.org>
References: <1e2.143843bf.2cf4ca4c@aol.com> <20031125154043.GK17908@hvs.envisage.co.za>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-xfs-bounce@oss.sgi.com>
In-Reply-To: <20031125154043.GK17908@hvs.envisage.co.za>
Errors-to: linux-xfs-bounce@oss.sgi.com
To: Hendrik Visage <hvisage@envisage.co.za>
Cc: AndyLiebman@aol.com, linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

On Tue, 25 Nov 2003, Hendrik Visage wrote:
> On Tue, Nov 25, 2003 at 10:07:56AM -0500, AndyLiebman@aol.com wrote:
> > A puzzle.
> > I have a P4-3.06 with 1 GB RAM. I have hyperthreading enabled -- and Mandrake
> > 9.2 (2.4.22 kernel) shows that I have 2 CPUs.
>
> I've seen similar troubles with the SuSE kernels. I believe it has
> something to do with some of the desktop/interactive patches that fills
> up memory too much before flushing caches.
>
> > Although data is coming into my Linux machine at a rate of 18 MB/sec, I don't
> > see any disk activity for as much as 30 or 40 seconds after I begin recording
> > video. Looking at XOSVIEW, I can see on the memory display that the cache
> > fills up until my memory is almost entirely full, and ONLY THEN does the disk
> > writing activity begin.
> >
> > Usually this is fine, but once in a while -- after capturing video for 20
> > minutes or so, the system will have a "hiccup" and fail to write data fast
> > enough. My video editing application will then stop capturing. I don'
>
> Play with the settings of:
> sysctl -a | grep vm.bdflush
> vm.bdflush = 30 500     0       0       500     3000    60      20      0
>
> I've found the right settings would alleviate this hiccup issue.

Is there any guidance or documentation on how to set those values?

-- 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Lonni J Friedman				netllama@linux-sxs.org
Linux Step-by-step & TyGeMo		     http://netllama.ipfox.com
