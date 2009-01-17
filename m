From: "Sujit Karataparambil" <sjt.kar@gmail.com>
Subject: Re: RAID 6 recovery (it's not looking good) *Even More problems*
Date: Sat, 17 Jan 2009 20:08:45 +0530
Message-ID: <921ca19c0901170638q2077ba97q6d08050bf3e2c228@mail.gmail.com>
References: <921ca19c0901170547u57f394d9kd7b9a736bc57da67@mail.gmail.com>
	 <C5979771.C0E4%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C5979771.C0E4%groups@email.iain.rauch.co.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > How did you copy the super block.
> >
> Not sure what you mean there? Which superblock?

I mean did you use some tool like Ghost(database backup software).

> > did you run fsck after booting you could set up that.
> >
> > http://www.cyberciti.biz/faq/linux-force-fsck-on-the-next-reboot-or-boot-seque
> > nce/
> Not sure why this will be helpful? There's not an independent file system on
> each md device is there?

Even an single filesytem requires you sync the upgrades or down grades.
