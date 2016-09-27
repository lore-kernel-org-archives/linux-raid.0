From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Tue, 27 Sep 2016 01:42:18 -0500
Message-ID: <0ac77bdb-0095-b114-b0dd-b6b0aa512ca9@gmail.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Well, I maybe found the problem.

1: I had an unhappy fan in the system -- and it's the one that cools the card slot area...

2: I think the controller card was getting warm anyway -- so I also changed the venting and put a temp sensor (CrystalFontz SCAB don'tcha know.. with dallas 1820 1-wire thermometers)... so I'm gonna keep an eye on it now.

3: I set up Munin to keep track of mismatch_cnt on all volumes. Didn't even know it existed.. :( wish I had history. I will now going forward.

I'll let ya'all know.

As usually... awesome help -- thanks!

 -Ben

