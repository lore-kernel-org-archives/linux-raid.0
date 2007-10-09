From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 9 Oct 2007 16:42:52 +0200
Message-ID: <20071009164252.790a35c0@absurd>
References: <20071008211313.6cd8bbb5@absurd>
 <470AB496.5010406@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <470AB496.5010406@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev said:     (by the date of Tue, 09 Oct 2007 02:52:06 +0400)

> Janek Kozicki wrote:
> > Hello,
> > 
> > Recently I started to use mdadm and I'm very impressed by its
> > capabilities. 
> > 
> > I have raid0 (250+250 GB) on my workstation. And I want to have
> > raid5 (4*500 = 1500 GB) on my backup machine.
> 
> Hmm.  Are you sure you need that much space on the backup, to
> start with?  Maybe better backup strategy will help to avoid
> hardware costs?  Such as using rsync for backups as discussed
> on this mailinglist about a month back (rsync is able to keep
> many ready to use copies of your filesystems but only store
> files that actually changed since the last backup, thus
> requiring much less space than many full backups).

yes, exactly. I am using rsnapshot, which is based on rsync and
hardlinks. It works exceptionally well - to my knowledge it's the
best backup solution I have ever seen. With plugin scripts I am even
mounting an lvm-snapshot of the drive being backupped.

from command 'rsnapshot du' I can see how many space is used (but
each directory tree is a full backup (made with hardlinks)):

278G    /backup/.sync
454M    /backup/hourly.0/
515M    /backup/hourly.1/
527M    /backup/daily.0/
30G     /backup/daily.1/
21G     /backup/daily.2/
561M    /backup/daily.3/
1.6G    /backup/daily.4/
3.0G    /backup/daily.5/
594M    /backup/daily.6/
1.4G    /backup/weekly.0/
11G     /backup/weekly.1/
9.3G    /backup/weekly.2/
23G     /backup/weekly.3/
33G     /backup/monthly.0/
3.7G    /backup/monthly.1/
415G    total


> It's definitely not possible with raid5.  Only option is to create a
> raid5 array consisting of less drives than it should contain at the
> end, and reshape it when you get more drives, as others noted in this
> thread.  But do note the following points:

<..snip..>

yes, I am aware of all those problems you listed. The data I'm
talking about is already a backup. While the real data is on my
workstation (a different linux box - albeit only the newest version
of my data). Only losing both of them simultaneoulsy will be
catastrophic for me. 

So I am inclined to do some experiments with the backup drives
configuration, while still doing my best at not losing it. An
exercise, you know :)

> > is it just a pipe dream?
> 
> I'd say it is... ;)

oh well. But I learnt a lot from your answers, thanks a lot!


PS: I'm receiving some mailing list posts twice, anybody knows why?
I'm used to mailman but looks like majordomo is being configured in a
different way - I cannot find a configure page. (I just subscribed).

-- 
Janek Kozicki                                                         |
