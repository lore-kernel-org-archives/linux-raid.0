From: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Subject: Re: problem with software raid1 on 2.6.22.10: check/rebuild hangs
Date: Mon, 3 Dec 2007 10:00:27 +0100
Message-ID: <200712031000.27768.wolfgang.walter@studentenwerk.mhn.de>
References: <200712030305.50109.wolfgang.walter@studentenwerk.mhn.de> <18259.29026.622217.229830@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18259.29026.622217.229830@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Montag, 3. Dezember 2007 04:00 schrieb Neil Brown:
> On Monday December 3, wolfgang.walter@studentenwerk.mhn.de wrote:
> > Hello,
> >
> > with kernel 2.6.22.10 checking a raid1 or rebuilding ist does not w=
ork on
> > one of our machines. After a short time the rebuild/check does not =
make
> > progress any more . Processes which then access the filesystems on =
those
> > raids are blocked.
> >
> > Nothing gets logged. Access to other filesystems works fine.
> >
> > If we boot 2.6.17.10 (the kernel we used befor upgrading to 2.6.22)=
 the
> > raids the check/rebuild is done without any problems.
>
> Sounds like a driver problem.
> Your symptoms are completely consistent with a request being submitte=
d
> to the underlying device, and that request never completing.
>
> What controller runs your drives for you.  You should probably report
> the problem to the relevant maintainer.

3ware Inc 9xxx-series SATA-RAID.

There are no problems with normal operation. And when those raids stop =
to work=20
all other disks on the same controller still work.

And I don't see problems when reading from several disk in parallel.

But this doesn't mean its not the driver, of course.

>
> Do you compile your own kernels?

Yes.

> Would you be comfortable using "git=20
> bisect" to narrow down exactly which change breaks things?  It should
> take more than a dozen or so tests.

Yes. Its a little bit difficult as I can only test kernels in the night=
 and on=20
weekend.

=46irst I have to see how to use git to get the repository and how to d=
o git=20
bisect.

>
> NeilBrown

Thanks and regards,
--=20
Wolfgang Walter
Studentenwerk M=FCnchen
Anstalt des =F6ffentlichen Rechts
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
