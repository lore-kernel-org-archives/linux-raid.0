From: John Robinson <john.robinson@yuiop.co.uk>
Subject: Re: mail notification of raid problems on 2.6.12
Date: Fri, 14 Nov 2008 16:23:01 +0000
Message-ID: <491DA5E5.9060507@yuiop.co.uk>
References: <20081023133959.GA29695@rap.rap.dk> <20081114154741.GA20271@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081114154741.GA20271@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/11/2008 15:47, Keld J=F8rn Simonsen wrote:
> On Thu, Oct 23, 2008 at 03:40:00PM +0200, Keld J=F8rn Simonsen wrote:
>> Hi list
>>
>> how do I get mail notification on kernel 2.6.12, mdadm v1.12.0?
>> I have looked in the man pages and tried various ways, but
>> without luck till now.
>=20
> I got no answers for this. Is it really not possible, or is this
> irrelevant to this list?

Your distro should set it up for you, otherwise set MAILADDR in your=20
mdadm.conf and run `mdadm --monitor`.

Cheers,

John.
--=20
John Robinson, yuiop IT services
0131 557 9577 / 07771 784 058
46/12 Broughton Road, Edinburgh EH7 4EE
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
