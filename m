From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: >16TB RAID0
Date: Sat, 18 Jul 2009 20:05:28 -0500
Message-ID: <20090719010529341.VWKI5000@cdptpa-omta04.mail.rr.com>
References: <bf9e24f010515d7b75e48872edcf68df.squirrel@neil.brown.name>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bf9e24f010515d7b75e48872edcf68df.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> But just to repeat: on a 64bit host, this is not an issue.  You can have
> devices so large that I don't know the correct greek prefix and they
> should still work.  It is only on 32bit hosts where 16TB can be
> a problem.

Assuming 512 byte sectors and an unsigned 64 bit integer sector table, 18
exabytes.

