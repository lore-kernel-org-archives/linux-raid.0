From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Curious code in autostart_array
Date: Thu, 22 Jun 2006 22:25:19 -0700
Message-ID: <20060622222519.095fcdfc.zaitcev@redhat.com>
References: <20060622210521.0aa68ec6.zaitcev@redhat.com>
	<17563.29205.266098.447047@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17563.29205.266098.447047@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, mingo@redhat.com, dledford@redhat.com
List-Id: linux-raid.ids

On Fri, 23 Jun 2006 14:46:13 +1000, Neil Brown <neilb@suse.de> wrote:

> > 		dev_t dev = MKDEV(desc->major, desc->minor);
> > 		if (MAJOR(dev) != desc->major || MINOR(dev) != desc->minor)
> > 			continue;

> desc->major and desc->minor have been
> read of the disk, so their values cannot be trusted.

Oh, right. Sorry.

-- Pete
