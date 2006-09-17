From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: RAID5 Problem - $1000 reward for help
Date: Sun, 17 Sep 2006 14:36:12 +0300
Message-ID: <5b170a7d0609170436w18fc6ff3r713284436c394fa7@mail.gmail.com>
References: <20060915090856.GD27597@boom.net>
	 <5b170a7d0609170037j52db8ec6u4f1603101e1718a@mail.gmail.com>
	 <B7838FAF-BD7D-4581-8E5C-8CB896AA3CC0@develooper.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B7838FAF-BD7D-4581-8E5C-8CB896AA3CC0@develooper.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Cc: Reza Naima <reza@reza.net>, linux-raid@vger.kernel.org, Taner Halicioglu <taner@taner.net>
List-Id: linux-raid.ids

On 9/17/06, Ask Bj=F8rn Hansen <ask@develooper.com> wrote:
> > It's recommended to use a script to scrub the raid device regularly=
,
> > to detect sleeping bad blocks early.
>
> What's the best way to do that?  dd the full md device to /dev/null?
>

echo check >/sys/block/md?/md/sync_action

Distros may have cron scripts to do this "right".

And you need a fairly recent kernel.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
