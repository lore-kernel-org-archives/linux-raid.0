From: Brennahn Chesteine <ven_ficken@yahoo.com>
Subject: Re: Last ditch effort for RH9 and LSR0
Date: Wed, 14 May 2003 06:35:28 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030514133528.99507.qmail@web14409.mail.yahoo.com>
References: <20030514013028.GV21216@somanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030514013028.GV21216@somanetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well I remember that I could not make my boot
partition RAID 0. That kinda ticked me off. You have
to understand, in my infiniate wisdom I purchaced a
Silicone Image ATA RAID card :( Yeah, stupid huh?

Has anyone ever used Vector Linux? I have it on my
laptop a 300 celery and it's ALOT lighter than RH,
wich I like. 

Is there a chance in heck that I could set up a
software RAID0 "root" parition before I install this
distro "Vector", then do the install? I have always
been able to install RH then rebuild X the WM and
kernel to my likeing but this has got me to a point to
where I will be up for learning something new. 

As for the RAM I have 512 but in order to install
Linux  on the main boxen I have to keep WinXP booted
in VMware ALWAYS for the woman so she can use the P.C.
Small price to pay in my opinion. 
--- Chris Davis <davis@lrtw.org> wrote:
> Here's what I know(or think I know):
>  - lilo can't boot from raid5 partitions.  If you
> want a raid5 root, 
>    make a raid1 or non-raid /boot and put your
> kernels there.
>  - raid0 swap is a bad idea.  If you just want
> bigger swap, just add two
>    swap partitions to fstab. Don't raid them, it's a
> performance hit.
> 
>    Also, you lose redundancy. If one of those
> partitions is damaged, or the
>    drive is, your machine could be toast if it was
> using swap. 
> 
>    Better is to raid1 the devices and use that as
> the swap partition. It's 
>    slower, but in 99.5% of cases, if you're worried
> about your swap speed,
>    you should really be adding more ram.
> 
> It possible that grub(i think rh9 uses grub by
> default) can boot from raid5.
> Maybe they have added a special module to make it
> work. I didn't think it
> could, but i could be wrong.
> 
> c
> 
> On Tue, 13 May 2003, Brennahn Chesteine wrote:
> 
> > I am at my witts and with trying to install a new
> > kernel under RH9. My system is set up with "root"
> and
> > "swap" in LSR0 and "/boot" in LSR5. I have taken
> all
> > know suggestions to get 2.4.20 to boot but nothing
> > after a month. 
> > 
> > I was wondering if anybody had managed to install
> a
> > new kernel under RH8or9 with a similar
> configuration.
> > And if so could they save there current config to
> a
> > file and shoot it this way so I can see what the
> heck
> > I am doing wrong. 
> > 
> > 
> > thanks for all the help thus far!
> > 
> > __________________________________
> > Do you Yahoo!?
> > The New Yahoo! Search - Faster. Easier. Bingo.
> > http://search.yahoo.com
> > -
> > To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at 
http://vger.kernel.org/majordomo-info.html


__________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo.
http://search.yahoo.com
