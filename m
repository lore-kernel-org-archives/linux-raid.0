From: "Jean-Rene Cormier" <jean-rene.cormier@cipanb.ca>
Subject: Re: Software RAID1 problems
Date: Sat, 1 Mar 2003 13:28:46 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <004901c2e01e$323fd500$8400a8c0@jrc>
References: <1045747209.795.7.camel@localhost.localdomain><15957.28314.314427.191061@notabene.cse.unsw.edu.au><002801c2db4b$6cac0c40$8400a8c0@jrc> <15961.19952.717406.146896@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Original Message -----
From: "Neil Brown" <neilb@cse.unsw.edu.au>
To: "Jean-Rene Cormier" <jean-rene.cormier@cipanb.ca>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, February 23, 2003 6:40 PM
Subject: Re: Software RAID1 problems


> On Thursday February 20, jean-rene.cormier@cipanb.ca wrote:
> > >
> > > I cannot explain the mounting problem.  Maybe if you give more
> > > specifics....
> >
> > Well what I did was:
> >
> > mdadm -Cv -l2 -n2 /dev/hde1 /dev/hdg1 /dev/md0
> > mke2fs -j /dev/md0
> > mount /dev/md0 /home
> >
> > then I unmounted it and when I tried to mount it again right after
> > unmounting it I got the Wrong FS type error and I get a bunch of error
> > message on the console.
>
> If that is really what you did, no wonder it didn't work.  The md
> device must be listed first, not last.
>
> However if it is a typo, and you really listed /dev/md0 first, it is
> strange.  Maybe if you could include the 'bunch of error messages' -
>    dmesg > /tmp/afile
> should get them for you.

Yes that was a typo sorry. I did reformat /dev/md0 and a when it started
formating it gave me those errors again. I did a little searching and the
problem is not in the raid array, but I'm still not sure what is causing the
problem. The error was:

hde: status error: status=0x58 { DriveReady SeekComplete DataRequest }
hde: drive not ready for command
hde: status timeout: status=0xf0 { Busy }
hde: drive not ready for command
ide2: reset: success

I get a bunch of those. I removed the drive and I reformated the array and
it works fine but I guess that if I put that drive back in it'll start doing
it again. Could it be a bad drive or something? If it is what's the use of
having a RAID-1 array if it corrupts your file system when a drive is bad?

Jean-Rene Cormier


