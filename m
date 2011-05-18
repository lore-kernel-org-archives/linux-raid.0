From: NeilBrown <neilb@suse.de>
Subject: Re: Unable to grow RAID 6 array
Date: Wed, 18 May 2011 18:56:53 +1000
Message-ID: <20110518185653.3dce0e9b@notabene.brown>
References: <20110518092327.airaicao@trusted.unix-scripts.info>
	<4DD37C24.6040307@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD37C24.6040307@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Laurent CARON <lcaron@unix-scripts.info>
List-Id: linux-raid.ids

On Wed, 18 May 2011 08:58:28 +0100 John Robinson
<john.robinson@anonymous.org.uk> wrote:

> On 18/05/2011 08:31, Laurent CARON wrote:
> > Hi,
> >
> > I'm basically trying to grow a RAID-6 array (5 disks).
> >
> > I did change the disks one by one (change, rebuild, ...).
> >
> > I finally did delete the last partition (the one I wanted to enlarge and
> > recreated it with the exactly same start but different end).
> >
> > When I try to grow the array, I get:
> >
> > # mdadm --grow --size max /dev/md2
> > mdadm: component size of /dev/md2 has been set to 732458496K
> [...]
> >
> > If any of you can help me to sort this out It would be nice.
> 
> You need to tell mdadm the underlying devices have grown; do this by 
> stopping the array then assembling it again with --update=devicesize. 
> Then when you --grow --size max you will get the result you are looking for.
> 

Alternately you could get this latest mdadm from 
   git://neil.brown.name/mdadm/

and run the "--grow --size max" command again.  It now updates the device
size too.
But John's answer is probably easiest.

NeilBrow
