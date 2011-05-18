From: Laurent CARON <lcaron@unix-scripts.info>
Subject: Re: Unable to grow RAID 6 array
Date: Wed, 18 May 2011 11:02:01 +0200
Message-ID: <20110518110049.ohyahtaz@trusted.unix-scripts.info>
References: <20110518092327.airaicao@trusted.unix-scripts.info>
 <4DD37C24.6040307@anonymous.org.uk>
 <20110518185653.3dce0e9b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110518185653.3dce0e9b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, May 18, 2011 at 06:56:53PM +1000, NeilBrown wrote:
> Alternately you could get this latest mdadm from 
>    git://neil.brown.name/mdadm/
> 
> and run the "--grow --size max" command again.  It now updates the device
> size too.
> But John's answer is probably easiest.

Hi,

I did pull the git tree and compile mdadm.

Worked as expected:

# ./mdadm --grow --size max /dev/md2
mdadm: component size of /dev/md2 has been set to 1709210112K

Did then grow the fs. Many thanks.

