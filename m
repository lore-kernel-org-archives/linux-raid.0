From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Mon, 23 Jan 2006 11:45:22 +0100
Message-ID: <20060123104522.GE2366@marowsky-bree.de>
References: <17360.9233.215291.380922@cse.unsw.edu.au> <20060120183621.GA2799@redhat.com> <20060120225724.GW22163@marowsky-bree.de> <20060121000142.GR2801@redhat.com> <20060121000344.GY22163@marowsky-bree.de> <20060121000806.GT2801@redhat.com> <20060121001311.GA22163@marowsky-bree.de> <20060123094418.GX2801@redhat.com> <20060123102601.GD2366@marowsky-bree.de> <20060123103851.GY2801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060123103851.GY2801@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <mauelshagen@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Phillip Susi <psusi@cfl.rr.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On 2006-01-23T11:38:51, Heinz Mauelshagen <mauelshagen@redhat.com> wrot=
e:

> > Ok, I still didn't get that. I must be slow.
> >=20
> > Did you implement some DM-internal stacking now to avoid the above
> > mentioned complexity?=20
> >=20
> > Otherwise, even DM-on-DM is still stacked via the block device
> > abstraction...
>=20
> No, not necessary because a single-level raid4/5 mapping will do it.
> Ie. it supports <offset> parameters in the constructor as other targe=
ts
> do as well (eg. mirror or linear).

An dm-md wrapper would not support such a basic feature (which is easil=
y
added to md too) how?

I mean, "I'm rewriting it because I want to and because I understand an=
d
own the code then" is a perfectly legitimate reason, but let's please
not pretend there's really sound and good technical reasons ;-)


Sincerely,
    Lars Marowsky-Br=E9e

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
