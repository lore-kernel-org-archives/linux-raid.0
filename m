From: <me@heyjay.com>
Subject: Re: Deleting an raid device
Date: Tue, 25 May 2004 08:27:57 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000701c4425e$47c246d0$6705a8c0@a30>
References: <002501c44257$7135dd80$6705a8c0@a30> <40B345B0.40108@wasp.net.au>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm using Debian, and mdadm.

I thought mdadm didn't us the /etc/raidtab file anymore

Jay
----- Original Message ----- 
From: "Brad Campbell" <brad@wasp.net.au>
To: <me@heyjay.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Tuesday, May 25, 2004 8:10 AM
Subject: Re: Deleting an raid device


> me@heyjay.com wrote:
> > Hi,
> >
> > What are the proper steps for deleting all remnants of a previous raid
> > install?
>
> <I inserted some lame joke here using /dev/zero and dd but I re-thought it
after picturing someone
> blindly doing a cut and paste, then cursing me for zeroing their boot disk
by mistake.>
>
> > I've done:
> > mdadm --stop /dev/md0
> > mdadm --zero-superblock /dev/md0
> >
> > But I still see it getting stopped on shutdown.
>
> Have you blitzed the /etc/raidtab file? (If you had one that is)
> You may be seeing your distribution trying to shutdown the array on
shutdown rather than something
> actually being stopped.
>
> Regards,
> Brad
>
>
>

