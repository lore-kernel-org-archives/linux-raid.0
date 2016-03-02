From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Checkarray doesn't seem to do anything
Date: Wed, 2 Mar 2016 19:08:23 +0100
Message-ID: <20160302180823.GA3294@lazy.lzy>
References: <20160301175009.0a91db92e0d9ae1e5e3fde0508678719.a1548d3694.wbe@email03.secureserver.net>
 <20160302174454.GA2567@lazy.lzy>
 <20160302224745.32db9c07@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160302224745.32db9c07@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, rodman@shellport.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 02, 2016 at 10:47:45PM +0500, Roman Mamedov wrote:
> On Wed, 2 Mar 2016 18:44:54 +0100
> Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:
> 
> > Just tested:
> > 
> > dd if=/sys/block/md0/md/sync_action bs=1 count=1
> > 
> > On kernel 3.x I get "i", on kernel 4.x I get "idle"... :-)
> 
> I am getting 'i' on 4.4.1.
> 
> # dd if=/sys/block/md0/md/sync_action bs=1 count=1
> i1+0 records in
> 1+0 records out
> 1 byte (1 B) copied, 0.000218199 s, 4.6 kB/s

Interesting.
I tested kernel 4.1.x (Ubuntu) and now 4.3.6 (Fedora 22).
They both deliver "idle".
On kernel 4.4.2 (Fedora 23) I get back the "i" alone...

Really funny... :-)

bye,

> 
> -- 
> With respect,
> Roman



-- 

piergiorgio
