From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Mon, 9 Nov 2009 15:43:52 -0600
Message-ID: <cccedfc60911091343t7d536626r99e9f3f0e6b0c26@mail.gmail.com>
References: <19187.50708.551325.297625@notabene.brown> <4AF829B2.5090001@redhat.com>
	<4AF836F8.5040903@panix.com> <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com>
	<alpine.DEB.1.10.0911091749320.22728@uplift.swm.pp.se> <4AF8847D.8030303@redhat.com>
	<20091109212705.GA29754@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091109212705.GA29754@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 9, 2009 at 3:27 PM, Luca Berra <bluca@comedia.it> wrote:
> On Mon, Nov 09, 2009 at 04:07:09PM -0500, Doug Ledford wrote:
>>
>> overwrite the superblock), I wouldn't make it 1.2 for whole disk
>> devices, and in fact it might be wise to refuse to create 1.2
>> superblocks on whole disk devices. =A0Just a thought.
>
> I am against refusing to do things because users could get confused,
> I could agree if this would require a force flag, but not deny
> completely.

Agree.

> I would think 1.1 is a good option for default. Better than 1.0 for
> reasons we discussed to boredom, and 1.2 is really only for special
> cases.

Agree.

> i also agree on the default chunk size bump

Agree.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
