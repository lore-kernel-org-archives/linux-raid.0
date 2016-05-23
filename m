From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] Need update superblock on time when deciding to do
 reshape
Date: Mon, 23 May 2016 17:19:41 -0400 (EDT)
Message-ID: <1653970376.53638422.1464038381331.JavaMail.zimbra@redhat.com>
References: <1463475249-18658-1-git-send-email-xni@redhat.com> <20160520175946.GA76216@kernel.org> <953124641.53356599.1463883247414.JavaMail.zimbra@redhat.com> <20160523190204.GA129477@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160523190204.GA129477@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "Shaohua Li" <shli@kernel.org>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org, "Jes Sorensen" <Jes.Sorensen@redhat.com>
> Sent: Tuesday, May 24, 2016 3:02:04 AM
> Subject: Re: [PATCH] Need update superblock on time when deciding to do reshape
> 
> On Sat, May 21, 2016 at 10:14:07PM -0400, Xiao Ni wrote:
> > 
> > 
> > ----- Original Message -----
> > > From: "Shaohua Li" <shli@kernel.org>
> > > To: "Xiao Ni" <xni@redhat.com>
> > > Cc: linux-raid@vger.kernel.org, "Jes Sorensen" <Jes.Sorensen@redhat.com>
> > > Sent: Saturday, May 21, 2016 1:59:46 AM
> > > Subject: Re: [PATCH] Need update superblock on time when deciding to do
> > > reshape
> > > 
> > > On Tue, May 17, 2016 at 04:54:09PM +0800, Xiao Ni wrote:
> > > > Hi all
> > > > 
> > > > If the disks are not enough to have spaces for relocating the
> > > > data_offset,
> > > > it needs to run start_reshape and then run mdadm --grow --continue by
> > > > systemd. But mdadm --grow --continue fails because it checkes that
> > > > info->reshape_active is 0.
> > > > 
> > > > The info->reshape_active is set to 1 when the superblock feature_map
> > > > have the flag MD_FEATURE_RESHAPE_ACTIVE. Superblock feature_map is set
> > > > MD_FEATURE_RESHAPE_ACTIVE as mddev->reshape_position != MaxSector.
> > > > 
> > > > Function start_reshape calls raid5_start_reshape which changes
> > > > mddev->reshape_position to 0. Then in md_check_recovery it updates the
> > > > superblock to underlying devices. But there is a chance that the
> > > > superblock
> > > > haven't written to underlying devices, the mdadm reads the superblock
> > > > data.
> > > > So mdadm --grow --continue fails.
> > > > 
> > > > The steps to reproduce this:
> > > > mdadm -CR /dev/md0 -l5 -n3 /dev/loop[0-2] --bitmap=internal
> > > > mdadm --wait /dev/md0
> > > > mdadm /dev/md0 -a /dev/loop3
> > > > mdadm --grow --raid-devices  4 /dev/md0
> > > > The loop device size is 500MB
> > > > 
> > > > [root@storageqe-09 ~]# cat /proc/mdstat
> > > > Personalities : [raid6] [raid5] [raid4]
> > > > md0 : active raid5 loop3[4] loop2[3] loop1[1] loop0[0]
> > > >       1021952 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4]
> > > >       [UUUU]
> > > >       [>....................]  reshape =  0.0% (1/510976) finish=0.0min
> > > >       speed=255488K/sec
> > > >       bitmap: 1/1 pages [4KB], 65536KB chunk
> > > 
> > > what's the bad effect of the --continue failure? I think reshape will
> > > still
> > > continue. Doing a update super there is ok, but I'm wondering if it's the
> > > good
> > > way. Could mdadm wait for MD_FEATURE_RESHAPE_ACTIVE then let systemd run?
> > > Because sounds like we are working around systemd bug, kernel itself will
> > > write
> > > superblock anyway soon, so we probably working around in userspace.
> > 
> > There is no bad effect if --continue failure. It just miss one chance to
> > go on reshaping. Yes, as you said we can fix this in userspace. I tried
> > to start mdadm-grow-continue@.service 30 seconds later as
> > mdadm-last-resort@.service
> > does. It can fix this too.
> > 
> > Sure it should be fixed this if mdadm try more times to check
> > MD_FEATURE_RESHAPE_ACTIVE.
> >  
> > > 
> > > > unused devices: <none>
> > > > 
> > > > So if we update the superblock on time, mdadm can read the right
> > > > superblock
> > > > data.
> > > > 
> > > > Signed-off-by <xni@redhat.com>
> > > > 
> > > > ---
> > > >  drivers/md/md.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > index 14d3b37..7919606 100644
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -4350,6 +4350,7 @@ action_store(struct mddev *mddev, const char
> > > > *page,
> > > > size_t len)
> > > >  			else {
> > > >  				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> > > >  				err = mddev->pers->start_reshape(mddev);
> > > > +				md_update_sb(mddev, 1);
> > > 
> > > write super even err != 0?
> > 
> > Ah, sorry for this. It should update superblock only err is 0.
> > 
> > At first I want to fix this in userspace, but I ask myself why shouldn't
> > update
> > the superblock once start_reshape returns. There are some guys waiting for
> > the
> > update. The function action_store should update the superblock in time to
> > tell
> > the colleagues what happens now. Then I checked the places where
> > md_update_sb
> > is called. I found it is indeed called in some places where the md device
> > changes. So I sent the patch here.
> > 
> > By the way, in size_store it update the superblock when err != 0. Is it
> > right
> > to check err there?
> 
> I think we should. probably nobody noticed it before.
> 

So does it mean you applied the way fixing the problem in kernel space? If
you apply the method I'll re-send the patch.

Best Regards
Xiao
