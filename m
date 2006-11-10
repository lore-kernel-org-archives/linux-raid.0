From: Jacob Schmidt Madsen <jacob@mungo.dk>
Subject: Re: How to recover from massive disk failure
Date: Fri, 10 Nov 2006 02:06:22 +0100
Message-ID: <200611100206.22366.jacob@mungo.dk>
References: <200611100150.39878.jacob@mungo.dk> <17747.52672.339031.967070@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17747.52672.339031.967070@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you very much for the quick answer!

One last one...

This is how my entry in mdadm.conf look:
DEVICE /dev/sd[bcdefg]1
ARRAY /dev/md5 level=raid5 num-devices=6 
UUID=a4a5dae9:04a09c3a:cd3fd7be:b754f4fe 
devices=/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1,/dev/sdg1

Do the order of the devices matter?

Thanks again!

On Friday 10 November 2006 01:54, Neil Brown wrote:
> On Friday November 10, jacob@mungo.dk wrote:
> > # mdadm -As /dev/md5
> > mdadm: /dev/md5 assembled from 2 drives - not enough to start the array.
> >
> > No luck!
> >
> > What can i do to get it up and running again?
>
> Add a "--force" flag.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
