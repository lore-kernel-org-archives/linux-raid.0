From: Derek Piper <derek.piper@gmail.com>
Subject: Fwd: RAID5 drive failure, please verify my commands
Date: Tue, 18 Jan 2005 12:42:34 -0500
Message-ID: <eaa6dfe05011809426d3a3a0b@mail.gmail.com>
References: <eaa6dfe050118074677f4bd6f@mail.gmail.com>
	 <200501181712.j0IHCU903873@www.watkins-home.com>
	 <eaa6dfe050118094248eb03ad@mail.gmail.com>
Reply-To: Derek Piper <derek.piper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eaa6dfe050118094248eb03ad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yea, SeaTools Enterprise says it uses the sg devices and it's for SCSI
disks. It looks like it runs tests similar to that that are triggered
by the -t option in 'smartctl'.

Hmm..I tried running the extended test (using smartctl). It completed
that okay and now says it's reallocated 137 sectors and has 2
uncorrectable ones, and the short test completes okay this time. Darn
drive, are you dying on me or not?

I've emailed the Seagate tech support people and see what they think
too. You can get a Seagate RMA just by entering the drive model and
serial # on the website. Doesn't say what consitutes a 'failure'
though, although I agree with you Mike, if it's got bad blocks then
it's 'bad' imho.

Thanks,

Derek

On Tue, 18 Jan 2005 12:10:21 -0500, Guy <bugzilla@watkins-home.com> wrote:
> You should download "SeaTools Enterprise".
> If this tool fails the drive, I think it is safe to return.
> The tool uses the sg devices.  I am not sure, but I think these are for SCSI
> devices.
>
> Guy
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Derek Piper
> Sent: Tuesday, January 18, 2005 10:46 AM
> To: linux-raid@vger.kernel.org
> Subject: Re: RAID5 drive failure, please verify my commands
>
> Since we're on the subject of RMA'ing hard drives, I have this
> question: I have a Seagate drive that during the course of running dd
> if=/dev/zero (a simple write-test I've done on all the 4 drives I am
> planning on using in my RAID1 set-up) on it has been shown to have
> errors (Drive Ready, Seek Complete .. blah blah). I used smartctl to
> have a look at the information the drive is giving and to get it to
> run a self-test. It apparently has reallocated 136 sectors, has 3
> uncorrectable sector errors and failed the read part of the short
> self-test with 90% to go. It says its health status is 'PASSED'
> though. 2 of the other drives have just a couple of errors and
> reallocated sectors, and one has never had an error.
>
> My question is this, to you knowledgable people, should I RMA it or do
> disk mfrs only replace drives if they are really DEAD? It's under
> warranty until June. Since I've never done it before I thought I'd
> ask, I'm thinking yes. The chick at Seagate kept telling me how to do
> the RMA process  when I was asking if a few unrecoverable sectors were
> covered. Has anyone RMA'd a drive only to have it sent back with 'nah,
> it's working fine'?
>
> Opinions are appreciated by anyone. Anyone that's dealt with Seagate,
> all the better :)
>
> Thanks,
>
> Derek
>
> On Mon, 17 Jan 2005 23:53:15 +0000, Robin Bowes
> <robin-lists@robinbowes.com> wrote:
> > Mike Hardy wrote:
> > >
> > >
> > > Gerd Knops wrote:
> > >
> > >> Hello all,
> > >>
> > >> One of the dreaded Maxtor SATA drives in my RAID5 failed, after just 3
> > >> months of light use. Anyhow I neither have the disk capacity nor the
> > >> money to buy it to make a backup. To make sure I do it correctly,
> > >> could you folks please double-check my intended course of action? I
> > >> would really appreciate that.
> > >
> > >
> > > Failed how? I have tons and tons of Maxtor drives in service, and only
> > > one actually had a complete failure (verified by their utility, which is
> > > present on some bootable CD I got called "UltimateBootDisk").
> >
> > Mike,
> >
> > When one of my drives fails I test it with the Maxtor Powermax tool -
> > it's this tool that is confirming that the drive(s) is(are) dieing.
> >
> > The only saving grace is the three-year warranty.
> >
> > R.
> > --
> > http://robinbowes.com
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
> --
> Derek Piper - derek.piper@gmail.com
> http://doofer.org/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--
Derek Piper - derek.piper@gmail.com
http://doofer.org/


-- 
Derek Piper - derek.piper@gmail.com
http://doofer.org/
