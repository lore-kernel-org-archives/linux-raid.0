From: berk walker <berk@panix.com>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 15:29:15 -0500
Message-ID: <423C8B9B.60808@panix.com>
References: <20050319162443.GR18819@marowsky-bree.de> <200503191744.j2JHiKT25357@www.watkins-home.com> <20050319175417.GU18819@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
In-Reply-To: <20050319175417.GU18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Guy <bugzilla@watkins-home.com>, "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree wrote:

>On 2005-03-19T12:44:14, Guy <bugzilla@watkins-home.com> wrote:
>
> =20
>
>>In the case of a split brain, I think one must be 100% voided, and a =
full
>>re-sync must be done.
>>   =20
>>
>
>Exactly. And that's where the bitmaps come into play; you can look at
>what is modified on each side, merge those sets, and copy all affected
>blocks from one side to the other; afterwards, you'll have a consisten=
t
>block device again.
>
>
>Sincerely,
>    Lars Marowsky-Br=E9e <lmb@suse.de>
>
> =20
>
And if your whole farm is an Oracle database?
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
