From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Sat, 21 Jan 2006 01:13:11 +0100
Message-ID: <20060121001311.GA22163@marowsky-bree.de>
References: <17358.52476.290687.858954@cse.unsw.edu.au> <43D00FFA.1040401@cfl.rr.com> <17360.5011.975665.371008@cse.unsw.edu.au> <43D02033.4070008@cfl.rr.com> <17360.9233.215291.380922@cse.unsw.edu.au> <20060120183621.GA2799@redhat.com> <20060120225724.GW22163@marowsky-bree.de> <20060121000142.GR2801@redhat.com> <20060121000344.GY22163@marowsky-bree.de> <20060121000806.GT2801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060121000806.GT2801@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <mauelshagen@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Phillip Susi <psusi@cfl.rr.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On 2006-01-21T01:08:06, Heinz Mauelshagen <mauelshagen@redhat.com> wrote:

> > A dm-md wrapper would give you the same?
> No, we'ld need to stack more complex to achieve mappings.
> Think lvm2 and logical volume level raid5.

How would you not get that if you had a wrapper around md which made it
into an dm personality/target?

Besides, stacking between dm devices so far (ie, if I look how kpartx
does it, or LVM2 on top of MPIO etc, which works just fine) is via the
block device layer anyway - and nothing stops you from putting md on top
of LVM2 LVs either.

I use the regularly to play with md and other stuff...

So I remain unconvinced that code duplication is worth it for more than
"hark we want it so!" ;-)



