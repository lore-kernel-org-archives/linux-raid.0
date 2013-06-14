From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Mdadm server eating drives
Date: Fri, 14 Jun 2013 16:20:21 -0500
Message-ID: <CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
	<51B896A2.9090105@websitemanagers.com.au>
	<CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com>
	<CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com>
	<CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com>
	<51BA7B28.9030808@turmel.org>
	<CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com>
	<CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Oops, again, sorry for the email issues, I'm having trouble getting
gmail to play right.

So now that I have a synced raid6, I'm looking at this problem of the
filesystem having been partially or fully corrupted, which happened
after a few components were ddrescued onto other components and force
assembled.  Is this something you might expect to happen in that
scenario?

mount /dev/md0 /media/vault               http://pastie.org/8042532

I do have a backup, so if it comes down to it, I can just make a new
filesystem and restore that way.  However the backup is not 100%
complete, so if possible id like to get the file system back, even
with errors, to supplement the missing part of the backup.

Is there any reason not to run "e2fsck -y /dev/md0"?

Thanks
