From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: change the initialization value for a spare device
 spot to MD_DISK_ROLE_SPARE
Date: Thu, 15 Jun 2017 10:02:57 -0700
Message-ID: <20170615170257.mvipqfor2t3rdxlg@kernel.org>
References: <20170612024555.1120-1-lzhong@suse.com>
 <20170613171708.roims6ja6vtuwwlo@kernel.org>
 <6e1c6747-f063-a99e-8358-9b994e2e8be2@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6e1c6747-f063-a99e-8358-9b994e2e8be2@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>
Cc: jes.sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 14, 2017 at 11:16:43AM +0800, Lidong Zhong wrote:
> 
> 
> On 06/14/2017 01:17 AM, Shaohua Li wrote:
> > On Mon, Jun 12, 2017 at 10:45:55AM +0800, Lidong Zhong wrote:
> > > The value for spare spot of sb->dev_roles is changed from
> > > MD_DISK_ROLE_FAULTY to MD_DISK_ROLE_SPARE to keep align
> > > with the value when the superblock is firstly created in
> > > userspace.
> > 
> > Could you point out where mdadm does this?
> > 
> Hi Shaohua,
> 
> It's done in init_super1() during initialization.
> 1615memset(sb->dev_roles,0xff,
> 
> 
> 1616            MAX_SB_SIZE - sizeof(struct mdp_superblock_1));
> 
> > I'm wondering what's the impact here. If there is a disk, we will set correct
> > role at the end of super_1_sync(), otherwise faulty sounds more reasonable.
> > 
> 
> Actually there is no impact if it works fine. I found the value for
> spare slot in sb->dev_roles is changed while debugging a problem.
> That's the reason I submit this patch.

ok, let's make it consistent, applied
