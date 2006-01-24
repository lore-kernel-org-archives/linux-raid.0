From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 000 of 7] md: Introduction - raid5 reshape mark-2
Date: Tue, 24 Jan 2006 10:23:03 +0100
Message-ID: <20060124092303.GD22870@marowsky-bree.de>
References: <20060124112626.4447.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060124112626.4447.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 2006-01-24T11:40:47, NeilBrown <neilb@suse.de> wrote:

> I am expecting that I will ultimately support online conversion of
> raid5 to raid6 with only one extra device.  This process is not
> (efficiently) checkpointable and so will be at-your-risk.

So the best way to go about that, if one wants to keep that option open
w/o that risk, would be to not create a raid5 in the first place, but a
raid6 with one disk missing?

Maybe even have mdadm default to that - as long as just one parity disk
is missing, no slowdown should happen, right?


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
