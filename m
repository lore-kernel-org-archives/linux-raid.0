From: Neil Brown <neilb@suse.de>
Subject: Re: Detecting array parameters
Date: Thu, 10 Jun 2010 08:31:12 +1000
Message-ID: <20100610083112.47aa2200@notabene.brown>
References: <20100609211340.GA12172@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100609211340.GA12172@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 9 Jun 2010 23:13:40 +0200
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Hi,
> 
> if I understood it correctly, in order to detect
> the several array parameters (number of disks, for
> example), it is possible to use "mdadm -D /dev/mdX"
> or to check the files in the corresponding /sys/block/...
> /mdX/... files.
> 
> Now, assuming something needs to be done in scripts,
> what would be the best way? Using "mdadm -D ... | grep"
> (or "mdadm ... | gawk ...."), or to read the proper
> files in /sys/block/md...?
> 
> Assuming the wanted information is available on both
> sides, which does not seem always the case.

If it is available in 
   mdadm --detail --export

I would use that.
Otherwise probably go for
   /sys/class/block/mdX/md/...

I say /sys/class/block rather than /sys/block as there are rumours of
deprecating /sys/block.  Don't know if that will ever happen though.

NeilBrown
