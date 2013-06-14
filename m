From: Phil Turmel <philip@turmel.org>
Subject: Re: Mdadm server eating drives
Date: Fri, 14 Jun 2013 17:30:46 -0400
Message-ID: <51BB8B86.9050803@turmel.org>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <51B896A2.9090105@websitemanagers.com.au> <CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com> <CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com> <CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com> <51BA7B28.9030808@turmel.org> <CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com> <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com> <CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com> <51BB8A67.5000605@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51BB8A67.5000605@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/14/2013 05:25 PM, Phil Turmel wrote:
> On 06/14/2013 05:20 PM, Barrett Lewis wrote:

>> Is there any reason not to run "e2fsck -y /dev/md0"?
> 
> An fsck is often needed after one of these crises.  So, yes.

After wrapping my head around the grammar... *No*, no reason to not run
fsck.

:-)

Phil

