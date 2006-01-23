From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Mon, 23 Jan 2006 11:26:01 +0100
Message-ID: <20060123102601.GD2366@marowsky-bree.de>
References: <17360.5011.975665.371008@cse.unsw.edu.au> <43D02033.4070008@cfl.rr.com> <17360.9233.215291.380922@cse.unsw.edu.au> <20060120183621.GA2799@redhat.com> <20060120225724.GW22163@marowsky-bree.de> <20060121000142.GR2801@redhat.com> <20060121000344.GY22163@marowsky-bree.de> <20060121000806.GT2801@redhat.com> <20060121001311.GA22163@marowsky-bree.de> <20060123094418.GX2801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932447AbWAWK0u@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060123094418.GX2801@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Heinz Mauelshagen <mauelshagen@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Phillip Susi <psusi@cfl.rr.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On 2006-01-23T10:44:18, Heinz Mauelshagen <mauelshagen@redhat.com> wrot=
e:

> > Besides, stacking between dm devices so far (ie, if I look how kpar=
tx
> > does it, or LVM2 on top of MPIO etc, which works just fine) is via =
the
> > block device layer anyway - and nothing stops you from putting md o=
n top
> > of LVM2 LVs either.
> >=20
> > I use the regularly to play with md and other stuff...
>=20
> Me too but for production, I want to avoid the
> additional stacking overhead and complexity.

Ok, I still didn't get that. I must be slow.

Did you implement some DM-internal stacking now to avoid the above
mentioned complexity?=20

Otherwise, even DM-on-DM is still stacked via the block device
abstraction...


Sincerely,
    Lars Marowsky-Br=E9e

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
