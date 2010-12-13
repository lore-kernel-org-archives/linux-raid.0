From: Neil Brown <neilb@suse.de>
Subject: Re: md device renaming
Date: Mon, 13 Dec 2010 13:49:20 +1100
Message-ID: <20101213134920.70512086@notabene.brown>
References: <4D0586D1.2040501@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D0586D1.2040501@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick H." <linux-raid@feystorm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 12 Dec 2010 19:37:05 -0700 "Patrick H." <linux-raid@feystorm.net>
wrote:

> So, every time I start up this md device with a specified name, it 
> renames itself to something else.
> 
> When I first created the array, I typo'd the name as 'nas01:isci-sdb1' 
> (should be nas01:iscsi-sdb1). And now every time I assemble it with the 
> correct name, it renames itself:
> 
> # /sbin/mdadm -A /dev/md/nas01:iscsi-sdb1 --uuid 
> abddf4ea:06524e68:8e2b8f4e:1b24c56d -R -U name
> mdadm: /dev/md/nas01:iscsi-sdb1 has been started with 2 drives (out of 3)
> # ls /dev/md/nas*
> /dev/md/nas01:isci-sdb1
> # ls /dev/disk/by-id/md-name*
> /dev/disk/by-id/md-name-nas01:iscsi-sdb1
> # mdadm -D /dev/md/nas01:isci-sdb1|grep Name
>            Name : nas01:iscsi-sdb1  (local to host nas01)
> 
> 
> So, notice how it says it started it as "nas01:iscsi-sdb1", however once 
> its up and I do the `ls`, it has the original name on it. I've tried -U 
> name to update the name on it when its assembled, but doesnt do a thing.
> 
> Am I missing something here. Shouldnt it be assembling itself with the 
> specified name I gave it, not the original name? And then how do I 
> update it so the name in the metadata is correct?
> (and yes I know its missing a drive, I'm testing some stuff out)

It is assembling it with the name you give it, but the name stored in the
metadata is still the old name.
Try adding --update=name to the --assemble command.

NeilBrown
