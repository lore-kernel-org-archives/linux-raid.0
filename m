From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: error during raid config
Date: Fri, 16 Jan 2004 15:31:03 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401162031.i0GKV8i14933@dns1.watkins-home.com>
References: <011620042013.18826.45cf@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <011620042013.18826.45cf@comcast.net>
To: gannan10@comcast.net, 'Steven Ihde' <sihde@cs.stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Give output of df command.  If hda1 is listed, then unmount it!

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of gannan10@comcast.net
Sent: Friday, January 16, 2004 3:14 PM
To: Steven Ihde
Cc: linux-raid@vger.kernel.org
Subject: Re: error during raid config

so what do I do now???
> On Fri, Jan 16, 2004 at 06:18:07PM +0000, gannan10@comcast.net wrote:
> > Hello,
> > 
> > I get the following error when I tried to setup my raid:
> > 
> > # mkraid /dev/md0
> > handling MD device /dev/md0
> > analyzing super-block
> > disk 0: /dev/hda1, 489951kB, raid superblock at 489856kB
> > /dev/hda1 is mounted
> > mkraid: aborted, see the syslog and /proc/mdstat for potential clues.
> 
> I use mdadm, not mkraid, but it appears the problem is right there:
> "/dev/hda1 is mounted".  Probably if you have a mounted filesystem on
> /dev/hda1, you cannot add it to the raid array.  Once you've created
> the raid array you can mount /dev/md0 instead of /dev/hda1.
> 
> -Steve
> 
> 
> 

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


