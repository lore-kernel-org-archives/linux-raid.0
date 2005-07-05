From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: mdadm memory leak?
Date: Tue, 5 Jul 2005 00:59:42 -0400
Message-ID: <200507050459.j654xlE06886@www.watkins-home.com>
References: <42CA0CEF.1080603@shlrm.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42CA0CEF.1080603@shlrm.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Kowis' <dkowis@shlrm.org>, linux-raid@vger.kernel.org
Cc: 'Eric Sandall' <eric@sandall.us>
List-Id: linux-raid.ids

Run "ipcs" to see if you have shared memory usage that seems wrong, or
grows.

# ipcs -m

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status

I have none, but I don't have a database.  Databases I have used on other
systems tend to use a lot of shared memory.

Also, if you were really out of memory, you would have active swapping.

It is normal for the buffer cache to use most "unused" memory, so it would
seem like you have almost none free, but the buffer cache will give up
memory when needed.  I think you have another problem, not memory related.
Also, you can stop mdadm from running.  The system will still work, just not
monitor the arrays.  If you really think it is mdadm related, kill it.  Or
use "/etc/init.d/mdmonitor stop".  At least as a test.

Run top, look at this line:
Mem: 515296k av, 508128k used, 7168k free, 0k shrd,  128412k buff

I think buff (128412k) is the amount of "unused" memory.  But not sure.  I
never had a memory issue with Linux, so have not researched this.  But I
have on other Unixes.

Guy

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of David Kowis
> Sent: Tuesday, July 05, 2005 12:31 AM
> To: linux-raid@vger.kernel.org
> Cc: Eric Sandall
> Subject: Re: mdadm memory leak?
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> whoops, I was mistaken, and a fool for not checking, but I don't use XFS,
> it's reiserfs on the 200gb array.
> Sorry about the second mail.
> 
> David Kowis wrote:
> > I'm not entirely sure if this is mdadm's fault, but I cannot find
> anything else that would cause the problem, since mdadm is the only new
> > thing and I'm pretty sure it's not 2.6.11.12's fault. Anyways, on to my
> issue:
> > I'm running samba, apache2, mysql, postgresql, and a few other things.
> I've got an Athlon-XP 1700+ with 768Mb RAM. Right after startup I've
> > got about 600Mb of free memory, and as time progresses, and I use samba
> for things (playing an MP3,) my amount of free memory declines
> > rather rapidly. It hovers around 8Mb of free ram, with no swap usage.
> The computer has bogged down bad enough that oom-killer has had to
> > kill just about everything. ps and top don't show anything eating up all
> my memory. I'm very impressed with mdadm and I'd like to keep using
> > it, but i'd also like to have a bit of free memory on my computer. I'm
> using an XFS file system on a 200Gb mirrored RAID array, two drives,
> > on seperate IDE channels (seperate cables.)
> > Thanks for your time,
> 
> - --
> David Kowis
> 
> ISO Team Lead - www.sourcemage.org
> SourceMage GNU/Linux
> 
> One login to rule them all, one login to find them. One login to bring
> them all, and in the web bind them.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (MingW32)
> 
> iD8DBQFCygzvtgErhgxHMHsRAp5+AJsHDK40HwrDu+G4KT4d7zotJTXV0QCeLf3E
> wqSc7wKPBHuTPOyruAuJOKY=
> =yXjm
> -----END PGP SIGNATURE-----
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

