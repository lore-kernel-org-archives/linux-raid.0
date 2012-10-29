From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Mon, 29 Oct 2012 16:06:13 -0200
Message-ID: <CAH3kUhEYz6+wsBoyDftP=+8YxhKpMBHwBAqK_oEeTm4_GRKDgQ@mail.gmail.com>
References: <508D808A.7040100@curtronics.com>
	<CAH3kUhHX28yNXggLuA+D_cH0STY-Rn_BjxVt_bh1sMeYLnM0cw@mail.gmail.com>
	<508E9289.5070904@curtronics.com>
	<CAH3kUhEdOO+GXKK6ALFUYJdYeTw2Mx-PF9M=0vQvkzzidihxSg@mail.gmail.com>
	<Pine.LNX.4.64.1210291148140.19033@router.curtronics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1210291148140.19033@router.curtronics.com>
Sender: linux-raid-owner@vger.kernel.org
To: Curt Blank <curt@curtronics.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maybe you want a 'cache', there's bcache and others patchs to kernel
that make harddisk 'hibrid' (ssd+hdd), it's nice and have a good
future in my opnion, google it, and tell what you think

2012/10/29 Curt Blank <curt@curtronics.com>
>
> Thanks. That made me think. Since as I said it's mainly going to contain
> the Linux OS that lessens my concern because of the static nature of those
> files. With the exception of /var/log and the MySQL DB's. /var/log files
> are rotated on a 24 hour basis, kept, then gzip'd after 14 days then kept,
> pretty much forever as long as space is available. MySQL DB's are mostly
> insert with some updates with the exception of the ZoneMinder DB which is
> mostly inserts and deletes continuously, majority of the data seldom lives
> past a month or two.
>
> I can maybe see the need for TRIM on /var/log and maybe /mysql and
> possibly /usr/local (which is it's own MP) where I do all my code
> development.
>
> Like I said, I'm not against compiling a kernel I just really don't want
> to have to do that every time the distribution updates and installs a new
> one.
>
> So still looking for a way to use TRIM with RAID1 which gets me back to
> the LVM option I heard might work?
>
> Also trying to find out if using my raid card might be the ticket but if
> not then it have to be the kernel if I want TRIM.
>
> On Mon, 29 Oct 2012, Roberto Spadim wrote:
>
> > trim is used by file system to clean space to new files be writen, in other
> > words, if you never need new space you won't need trim
> > does your application a log like app? if yes trim is useless, the only use
> > here is if you delete old log files and it normally is very rare, maybe
> > once a month, maybe a week?
> >
> > if you need always delete files and write new ones, yes trim can help you
> > but it will not save your life, it give more 'clean' space to garbage
> > collect of ssd, and ssd don't reuse spaces with informations, it will use
> > new ones, so in other words a trim help ssd to write faster and dont do
> > (read-merge-write)
> > vertex 4 have a good firmware, i used a vertex 2 some years ago without
> > trim, and it runs nice with mysql in a generic aplication with delete
> > update select, it execute >300iops very easly, and 300MB/s too, i didn't
> > checked a slow don't after some time using it, so i don't see why trim
> > could speed a lot my app,
> > try, and say what you got, it's not unsafe, and sounds good, i don't know
> > about suse kernel support, but it's not hard to compile a new kernel if you
> > need it
> >
> > i used the vertex2 in raid1 configuration (it's better for many threads
> > apps like mysql, but worst for stream application, for stream a raid10 or
> > raid0 is better)
> >
> >
> > 2012/10/29 Curtis J Blank <curt@curtronics.com>
> >
> > >  Could you explain this a little more please? I don't understand why
> > > applications come into play? Thought the file system, in this case ext4,
> > > handles space allocation on the device not any application.
> > >
> > > And here again, I don't need TRIM, but everything I've been reading, even
> > > from the SSD manufacturer, OCZ, says you do need TRIM to reduce write
> > > amplification.
> > >
> > > If you don't need TRIM that makes things easy but my concern is write
> > > amplification over time.
> > >
> > > [Had to resend, got rejected due to "reason: 550 5.7.1 Content-Policy
> > > reject msg: The message contains HTML subpart, therefore we consider it
> > > SPAM or Outlook Virus." from ThunderBird]
> > >
> > >
> > > On 10/29/12 07:20, Roberto Spadim wrote:
> > >
> > > if you don't have DELETE and DROP in you application, you don't need
> > > TRIM...
> > >
> > > 2012/10/28 Curtis J Blank <curt@curtronics.com>
> > >
> > >> I've got two new SSD's that I want to set up as RAID1 and use strictly
> > >> for the OS and MySQL DB's partitioned accordingly.
> > >>
> > >> I'll be using the 3.4.6 kernel for now in openSuSE 12.2 with ext4. So
> > >> after a lot of Google'n and reading it is my understanding that discard is
> > >> not sent to the devices via the raid drivers. I am aware of Shaohua Li's
> > >> patches to make it work but am not inclined to use them due to openSuSE's
> > >> Online Update replacing the kernel. I'm not against patching and gen'ing a
> > >> kernel, that used to be SOP, but just don't want deal with that overhead.
> > >> Of course unless I really need to.
> > >>
> > >> So I've read, and if I understand things correctly, I can use LVM and
> > >> RAID1 and the the discard commands will be sent to the devices. Is that
> > >> correct and currently the only way or is/are there other ways?
> > >>
> > >> I've also read that a lot of people are saying TRIM isn't needed because
> > >> the SSD's garbage collection is so good now TRIM isn't needed. But I don't
> > >> see how that could work because the SSD's don't have access to the file
> > >> system so they don't know which pages in the blocks are marked unused to do
> > >> any consolidation and erasing. And using TRIM is suggested in a OCZ
> > >> document I read and who's drives these are. Unless, the SDD when it has to
> > >> change a page moves the whole block then erases the old block? But without
> > >> TRIM in could be moving invalid data too because it doesn't know that and
> > >> that to me sure doesn't sound efficient and this operation would be a
> > >> perfect time to get rid of the invalid data if it did know.
> > >>
> > >> And due to PEC I'm wondering if this is even a good idea? Granted the OS
> > >> files can be considered somewhat static, with the exception of /var/log so
> > >> maybe that shouldn't go on the SSD, and maybe MySQL shouldn't either
> > >> because for things like ZoneMinder it's DB is pretty dynamic. But with all
> > >> the logging going on, and there is a lot, and the dynamic nature of the
> > >> MySQL data is the exact reason I want it put it on SSD's, for the speed.
> > >> See my quandary?
> > >>
> > >> This is my best understanding of things right now so I came here to and
> > >> am asking the experts for help in clarifying and  understanding this and
> > >> pick the best direction to go. Have the SSD's for a couple of weeks now but
> > >> holding off using them until the I can determine the best way to use them.
> > >> Oh and the SSD's are OCZ Vertex 4 VTX4-25SAT3-256G.
> > >>
> > >> Thanks.
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > >> the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >>
> > >
> > >
> > >
> > >  --
> > > Roberto Spadim
> > >
> > >
> > >
> > >
> >
> >
> > --
> > Roberto Spadim
> >




--
Roberto Spadim
