From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Wed, 17 Nov 2004 12:04:57 +0000
Message-ID: <419B3E69.3020803@dgreaves.com>
References: <200411132039.iADKdDN07474@www.watkins-home.com>	<41968282.6060306@dgreaves.com> <4198DF79.8080809@dgreaves.com>	<41999A9B.2000907@wasp.net.au> <419B3435.3080707@dgreaves.com> <yw1x4qjog1lf.fsf@ford.inprovide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yw1x4qjog1lf.fsf@ford.inprovide.com>
Sender: linux-ide-owner@vger.kernel.org
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mru@inprovide.com>
Cc: Brad Campbell <brad@wasp.net.au>, Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

M=E5ns Rullg=E5rd wrote:

>David Greaves <david@dgreaves.com> writes:
> =20
>
>>I've been tracking this on the ide list and I've been nervous of
>>applying anything since I don't have proper  backups. I'm relying on
>>redundancy.
>>   =20
>>
>RAID can *never* replace proper backups.  RAID only protects against
>low-level disk failures.  Filesystem corruption caused by bugs,
>accidental deleting of files, etc. are happily allowed.  Get a DVD
>burner, you'll thank yourself one day.
> =20
>
Got one.
I have 935Gb of data (soon to be 1.2Tb)
Each DVD holds 4.7Gb and takes 20-30 mins to burn.
Any other ideas ? ;)

David

PS Seriously - the data is films, my CDs, DVDs, TV shows and the like.=20
It's a bummer to lose but in the grand scheme of things it's only the t=
elly.
My _real_ personal data (photos etc) are mirrored onto physically=20
seperate disks each night. The 'backups' are remounted read-only. It's=20
the 'rsync snapshot' method.

See: http://www.mikerubel.org/computers/rsync_snapshots/

Thanks for your concern though :)

