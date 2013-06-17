From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Mdadm server eating drives
Date: Mon, 17 Jun 2013 16:37:50 -0500
Message-ID: <CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
	<51B896A2.9090105@websitemanagers.com.au>
	<CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com>
	<CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com>
	<CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com>
	<51BA7B28.9030808@turmel.org>
	<CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com>
	<CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
	<CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com>
	<51BB8A67.5000605@turmel.org>
	<51BB8B86.9050803@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51BB8B86.9050803@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is terrific.  fsck found tons and tons of errors and fixed them
all.  Then I ran rsync -avHcn [array] [backup] and found 5 or so files
out of 8tb which had some slight corruption, which can easily be
restored from the backup but I was curious to do a dry run first to
use vbindiff and see what the corruption looked like at the byte
level.  Interesting!

I did notice that before rsync found one of the differences (corrupt
files) it started spitting out those same "failed
command: READ FPDMA QUEUED status: { DRDY ERR } error: { UNC }" errors
as before but this time it did not fail the drive.  I take this to
mean there is still some physical problems with the drive, but with
the new timeout settings it is not unnecessarily failing the drive out
of the array.  So if I overwrite the corrupted files with the backups,
(or write any new data to the array really), will it avoid those
problem areas on the platter?

I just want to say a big thanks as this has been causing me
indescribable stress and monetary cost for months since the beginning
of february and it looks like I am back in business.  I think I will
write some perl scripts to help monitor some of these things.
