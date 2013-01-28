From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 18:37:04 +0100
Message-ID: <20130128173704.GA2329@lazy.lzy>
References: <20130127192656.634892005AD@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130127192656.634892005AD@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 27, 2013 at 08:26:56PM +0100, Wolfgang Denk wrote:
[...]
> # cat /sys/block/md0/md/mismatch_cnt
> 362732152
> 
> 
> This is with mdadm v3.2.6 (mdadm-3.2.6-7.fc18.x86_64); except for the
> huge values of mismatch_cnt, I see no other indications for errors on
> the disk drives, RAID arrays or the file systems on top of these.
> 
> Is this some known (and hopefully harmless), issue, or must I worry
> about our data?
[...]


Hi Wolfgang,

I would shamelessly suggest to try "raid6check", in order
to see if some components have problems.

The software is somehow buried into "mdadm" source code,
probably you'll need to take it from the repository.

Hope it will help,

bye,

-- 

piergiorgio
