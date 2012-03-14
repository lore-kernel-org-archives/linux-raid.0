From: NeilBrown <neilb@suse.de>
Subject: Re: If
Date: Wed, 14 Mar 2012 13:51:24 +1100
Message-ID: <20120314135124.7693d36b@notabene.brown>
References: <201203131333334683559@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xY.Eerkx4GMojw0HfeImUDe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203131333334683559@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/xY.Eerkx4GMojw0HfeImUDe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Mar 2012 13:33:37 +0800 "kedacomkernel" <kedacomkernel@gmail.com>
wrote:

>  Hi,all:
> 	I met a question.=20
> 	When Raid5 is recoverying and other component disk had badblocks,the res=
ync thead always stop and restart.
> 	I think resync thread may stop and not need to restart.
>  			=09

I'm not sure what you mean.

Are you saying that it gets into an infinite loop, stopping and restarting.
Or are you saying that it stops, restarts once, and the stops completely?

NeilBrown

--Sig_/xY.Eerkx4GMojw0HfeImUDe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2AHrDnsnt1WYoG5AQIvMw//QIZ6GzvYxE6QZUzj/jQWTV3BjKjb6D7A
4w6agayh4T3AULLPrb0Iq/bur1ApNEdyyh5AZVXUcFOSSEpLsl0xCWlozHwPzzv2
Nd18k6tS9wJahWjnNLYU28zImo6uS1Oy74kTrPMQI+xeE+wcOCkPmZXsE3V5hCWh
AiUhpO/kuXTfavlDozHJmtSVkuFpi5kUufwEGpl9JZmfObNJ3ipeizJyYmqPUXf5
tUErP+pQzjgrgC8GAlIblarERi1cXks7yPX8qYy1DmECCB5Bph0MfFB/YQIW0g3z
4B8nGBwbllQd74E0DjaFOhCi9UFHiV3/hNgFuBCCfWwJvOQdiNlI4JmtLTdk7UXq
v2oU5IwGX4evU32JYmk1FvOfFP+oU0SezSW3lPvp7Lz7lYXyPFZSr9b+uw49/PlG
nTS9pWHFFt1hg8N8V452TkTFK+HUBNAWztxmWUn7Nl+vrQkFrD5zrvkc+vP3VLK8
d5fvCh6GSIy5pLAGsy2cTo64ojy5gN7Qj8aXeifYNOMpWKyTMjuZsDR8BSF5xKbC
V16rfj4d40boM6SbfnPoO0AAJ0vsCMR3Q3l+2CcnZ6lT/a2Jwfdqomj615H09nd+
5bhDb1j/iIG/3ckH7JMxHwGsH+7aCWmfXZtFjgvRAMsukK45Um4znGwMov4ZQOGh
w9MrlxjQb/E=
=u4hO
-----END PGP SIGNATURE-----

--Sig_/xY.Eerkx4GMojw0HfeImUDe--
