From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: recovering from a controller failure
Date: Sat, 29 May 2010 22:33:34 -0500
Message-ID: <12.2A.01646.B8CD10C4@cdptpa-omtalb.mail.rr.com>
References: <20100530001504.GE7501@flews.lairds.us>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100530001504.GE7501@flews.lairds.us>
Sender: linux-raid-owner@vger.kernel.org
To: 'Kyler Laird' <kyler-keyword-linuxraid00.a7e7f0@lairds.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Sun, May 30, 2010 at 09:50:26AM +1200, Richard wrote:
> 
> > How about adding entries to your mdadm.conf file containing the UUID
> > of /dev/md0, eg:
> >
> > ARRAY /dev/md8 level=raid6 num-devices=16
> > UUID=38a06a50:ce3fc204:728edfb7:4f4cdd43
> >
> > note this should be all one line.
> 
> I'll be happy to do that.
> 
> > mdadm -D /dev/md0 should get you the UUID.
> 
> 	root@00144ff2a334:/# mdadm -D /dev/md0
> 	mdadm: md device /dev/md0 does not appear to be active.
> 
> So...how do I get the UUIDs?  I tried blkid and got this.
> 	http://lairds.us/temp/ucmeng_md/uuids
> Those UUIDs are far from unique.

	After all your drives are visible, of course:

`mdadm --examine /dev/sd* /dev/hd* > <filename>`
`more <filename>`

Make note of the array UUID for each drive.  When done,

`mdadm --assemble --assume-clean /dev/mdX /dev/<drive0> /dev/<drive1>
/dev/<drive2> ...etc`

where <drive0>, <drive1>, etc are all members of the same array UUID.

	Mount the file system, and fsck it.  Once everything is verified
good,

`echo repair > /sys/block/mdX/md/sync_action`
`mdadm --examine --scan >> /etc/mdadm/mdadm.conf`

