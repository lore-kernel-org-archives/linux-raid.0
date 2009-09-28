From: adfas asd <chimera_god@yahoo.com>
Subject: RE: Remote NAS
Date: Mon, 28 Sep 2009 07:07:30 -0700 (PDT)
Message-ID: <41943.20139.qm@web38801.mail.mud.yahoo.com>
References: <20090927201849401.FXKG6584@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090927201849401.FXKG6584@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am puzzled by why write-mostly.  Ostensibly Gb ethernet is supposed to nearly equal the data transfer rate of the controller cards, and be many times the speed of actual data transfer from the drives.  

So shouldn't a NAS have plenty of bandwidth to accommodate most any drive operations?

I will be setting up a small high-perf drive for / (including database) so the only data on the array will be /home (including large videos).

Seems like there is no need to specify write-mostly?


--- On Sun, 9/27/09, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
>     In his situation (assuming he doesn't
> take my advice and separate
> the remote system entirely), wouldn't he be better served
> to create a RAIDn
> array on both systems and then create a RAID1 from the
> local and NAS array
> with the write mostly option?




      
