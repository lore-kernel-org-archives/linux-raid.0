From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Should "mdadm --add" complain if the new device appears to have
 a filesystem on it?
Date: Tue, 23 Jul 2013 19:17:54 +0200
Message-ID: <20130723171754.GA2109@lazy.lzy>
References: <20130723113902.62368e3e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130723113902.62368e3e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>, Christian Iversen <chrivers@iversen-net.dk>
List-Id: linux-raid.ids

Hi Neil,

On Tue, Jul 23, 2013 at 11:39:02AM +1000, NeilBrown wrote:
> 
> As you probably know, when you use "mdadm -C" to create an array, it will
> check if the devices appear to contain a filesystem or similar already and
> will complain if they do - requiring you do say "yes" or use "--run" to avoid
> the warning.
> 
> However if you use "--add" to add a device to an existing array no such
> checks are done.  So it isn't too hard to destroy all those cat photos you
> have saved on a USB drive (because device names change every time you boot
> and you got confused).
> 
> 
> I could easily change "--add" to be more cautious, but that might break
> existing scripts, which I would rather not do.

my 2 cents on this.
Advertise it properly and then change it.

I personally think that a bit of "safety" is worth
going thru the scripts to change them.
Not to mention, script will break only in case where
people have the chances to take action directly.

My guess would be that there are few automated scripts
adding devices with filesystem or similar on them.

bye,

pg

> Or I could add a "policy" line to mdadm.conf which would indicate the policy
> for "--add" - either "spare" or "force-spare".  But then I would need to
> decide on a default.  The default should probably be safe otherwise people
> probably won't change it until they get burned.  So people with scripts would
> still experience breakage, but could now fix it easily with a "policy" line.
> 
> Or maybe "--add" should be deprecated so people have to choose between
> "--re-add" or a new "--spare" with --spare requiring "--force" to destroy
> data.
> Then "--add" would generate a deprecation message which scripts could  ignore
> but people might learn from.
> 
> 
> I don't think there is an obviously-correct answer here so I'm open to
> suggestions.  What do people think?
> 
> NeilBrown



-- 

piergiorgio
