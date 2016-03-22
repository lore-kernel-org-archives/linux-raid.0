From: Chris Murphy <lists@colorremedies.com>
Subject: Re: problems with dm-raid 6
Date: Mon, 21 Mar 2016 22:22:30 -0600
Message-ID: <CAJCQCtQCEMdjAB5eoKB9SyXOdK6_5t+NsY39c=KCXgWqSLF0tQ@mail.gmail.com>
References: <20160321213829.GA16677@EIS>
	<trinity-226526b2-6058-40bf-a276-9c1b47a80b3b-1458600120646@3capp-gmx-bs35>
	<20160321230456.GA16913@EIS>
	<CAJCQCtRELEP8WxVpiS_E7i7raz+JbPOYTGvVvswCVHW__BC+nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtRELEP8WxVpiS_E7i7raz+JbPOYTGvVvswCVHW__BC+nA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Patrick Tschackert <Killing-Time@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 21, 2016 at 9:53 PM, Chris Murphy <lists@colorremedies.com> wrote:
 So even though
> there's a duplicate of the chunk tree, since there's only one logical
> address in the super for the chunk tree, if that logical address
> doesn't resolve to a sane physical location, there's no way to find
> out where any copies are. So it's stuck.

Small clarification. The Btrfs superblock contains four backups. But
in Patrick's case, all four backups contain the same chunk root
address as the primary entry in the super (all five copies are the
same address) so... yeah stuck. Basically that address has to become
viable to start to get access to one or more copies of the filesystem,
including the root tree which is also a logical address. So none of
the trees can be sorted out without the chunk tree. There is a chunk
recover option, but I'm very skeptical of it being able to do anything
when the btrfs-find-root command fails totally for Patrick. There's
just not enough information available.

So I think the key is to get at the least n-2 drives up in a degraded
array and then yes indeed we'll have magic, or unicorn poop cookies,
or whatever...


-- 
Chris Murphy
