From: "Scott Kaelin" <skaelin@gmail.com>
Subject: Re: [Iscsitarget-devel] [BUG] Raid1/5 over iSCSI trouble
Date: Fri, 19 Oct 2007 17:11:10 -0400
Message-ID: <278954460710191411q289c5fa0n6568dcae8aad8780@mail.gmail.com>
References: <4714BB92.7040701@systella.fr>
	 <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>
	 <47181CB2.1060602@tmr.com> <471864F8.9010209@systella.fr>
	 <1192809103.30976.11.camel@dwillia2-linux.ch.intel.com>
	 <4718DE66.8000905@tmr.com> <471916B5.6080709@systella.fr>
	 <47191855.4020402@systella.fr>
	 <E2BB8074E5500C42984D980D4BD78EF9017A296F@MFG-NYC-EXCH2.mfg.prv>
	 <47191C66.309@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <47191C66.309@systella.fr>
Content-Disposition: inline
Sender: sparclinux-owner@vger.kernel.org
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: "Ross S. W. Walker" <rwalker@medallion.com>, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, iscsitarget-devel@lists.sourceforge.net, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

[snip]
> >
> > I am unsure why you would want to setup an iSCSI RAID1, but before
> > doing so I would try to verify that each independant iSCSI session
> > is bullet proof.
>
>         I use one and only one iSCSI session. Raid1 array is built between a
> local and iSCSI volume.

So you only get this problem doesn't happen when doing I/O with only
the iSCSI session?

Wouldn't it be better to do the RAID1 on the target machine? Then you
don't need to mess around with weird timing behavior of remote/local
writing.

If you want to have the disks on 2 different machines and have them
mirrored DRDB is the way to go.

@Ross: He is trying mirroring his local drive with a iSCSI lun.

>
>         JKB
>
>
>



-- 
Scott Kaelin
Sitrof Technologies
skaelin@sitrof.com
