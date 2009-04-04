From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 4 Apr 2009 01:44:28 -0500
Message-ID: <20090404064430.NVRF28081.cdptpa-omta04.mail.rr.com@Leslie>
References: <20090402065648.GA15574@maude.comedia.it>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090402065648.GA15574@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>The issue is the entire array will occasionally pause completely for about
>>40 seconds when a file is created.  This does not always happen, but the
>>situation is easily reproducible.  The frequency at which the symptom
>i wonder how costly b-tree operaton are for a 8Tb filesystem...

I expect somewhat costly, but a 4 second to 2 minute halt just to create a
file of between 0 and 1000 bytes is ridiculous.  That, and as I said, it
doesn't always happen, by a long shot, not even when transfers in the 400
Mbps range are underway.  OTOH, I have had it happen when only a few Mbps
transfers were underway.

