From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH 0/6] raid6check fixes
Date: Fri, 28 Jun 2013 19:46:22 +0200
Message-ID: <20130628174622.GA2245@lazy.lzy>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
 <20130619100803.03fde6d5@notabene.brown>
 <20130620161639.GA3033@lazy.lzy>
 <20130624170458.568dafcb@notabene.brown>
 <20130624171016.GA2237@lazy.lzy>
 <20130625095422.29d3079b@notabene.brown>
 <20130625164628.GA2261@lazy.lzy>
 <20130627142719.5ffbf0ce@notabene.brown>
 <20130627204900.GA2240@lazy.lzy>
 <20130628071250.78db1f9b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130628071250.78db1f9b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org, Robert Buchholz <rbu@goodpoint.de>
List-Id: linux-raid.ids

On Fri, Jun 28, 2013 at 07:12:50AM +1000, NeilBrown wrote:
[...]
> Fair enough.  I was thinking in the context of making raid6check part of the
> default install.  I wouldn't want to do that until it was more "user
> friendly".  I also wouldn't want to do it until he code had stabilized.  So
> your idea fits perfectly.

Hi Neil,

seems reasonable, this discussion was exactly
triggered in order to understand what is missing
and what should be done for "raid6check" in
order to be part of the official "mdadm" binary set.

So, to sum it up:

1) 4K block size resolution for processing
2) Verbosity under controll

I guess these are the open points.

Thanks,

bye,

pg

> Thanks,
> NeilBrown
> 



-- 

piergiorgio
