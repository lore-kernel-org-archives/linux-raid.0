From: "NeilBrown" <neilb@suse.de>
Subject: Re: initiate consistency check using mdadm
Date: Thu, 23 Oct 2008 08:43:28 +1100 (EST)
Message-ID: <04eda08abe4ecb6ad04dd21259e07e1c.squirrel@neil.brown.name>
References: <8b25b3bc0810220447s1c0b5e1ega116682a58f9fcd1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8b25b3bc0810220447s1c0b5e1ega116682a58f9fcd1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias =?iso-8859-1?Q?Hellstr=F6m?= <hellstrom.mattias@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, October 22, 2008 10:47 pm, Mattias Hellstr=F6m wrote:
> To me it would be nice to use mdadm for all mdraid related tasks, as =
a
> convenient way to "cat /proc/mdstat" and writing check in the correct
> sync_action file etc.
>
> Is this out of scope for the tool? (Or just not yet coded)

Not yet coded.  Patches welcome.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
