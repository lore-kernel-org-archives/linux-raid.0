From: Drew <drew.kay@gmail.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 16:32:54 -0700
Message-ID: <c268e4660909151632i56e9f3f9n48f17cc827d974f0@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	<70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>
	<c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
	<70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>
	<B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com>
	<FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com> <4AAFFDC4.5090806@sauce.co.nz>
	<B15861F4-3F63-4D23-8B9A-DCB809C56C0C@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B15861F4-3F63-4D23-8B9A-DCB809C56C0C@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Greg Freemyer <greg.freemyer@gmail.com>, "Majed B." <majedb@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for the input.

Sounds from your testing like PMs can deliver the sorts of speeds that
are adequate for our needs. Have you done any testing as far as md
RAID using member disks from each PM?

Given we're expecting a mix of online and archival data going onto
this enclosure I was thinking about making up RAID arrays composed of
disks from each PM for online use and arrays composed of disks from a
PM for archival use.

I'm sorry if I keep throwing questions out without doing my own
testing. As I alluded to earlier I don't have an R&D budget for
testing so I have to be reasonably sure of my system before I can get
authorization to purchase kit.

-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
