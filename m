From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@inprovide.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Wed, 17 Nov 2004 12:24:28 +0100
Message-ID: <yw1x4qjog1lf.fsf@ford.inprovide.com>
References: <200411132039.iADKdDN07474@www.watkins-home.com>
	<41968282.6060306@dgreaves.com> <4198DF79.8080809@dgreaves.com>
	<41999A9B.2000907@wasp.net.au> <419B3435.3080707@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <419B3435.3080707@dgreaves.com> (David Greaves's message of
 "Wed, 17 Nov 2004 11:21:25 +0000")
Sender: linux-ide-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Brad Campbell <brad@wasp.net.au>, Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> writes:

> I've been tracking this on the ide list and I've been nervous of
> applying anything since I don't have proper  backups. I'm relying on
> redundancy.

RAID can *never* replace proper backups.  RAID only protects against
low-level disk failures.  Filesystem corruption caused by bugs,
accidental deleting of files, etc. are happily allowed.  Get a DVD
burner, you'll thank yourself one day.

--=20
M=E5ns Rullg=E5rd
mru@inprovide.com
