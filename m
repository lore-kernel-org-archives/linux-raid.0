From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: No resync
Date: Mon, 11 Jan 2010 22:52:43 -0600
Message-ID: <C6.49.19471.1200C4B4@cdptpa-omtalb.mail.rr.com>
References: <4B4BFE34.9090501@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B4BFE34.9090501@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: 'Richard Scobie' <richard@sauce.co.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Richard Scobie
> Sent: Monday, January 11, 2010 10:45 PM
> To: linux-raid@vger.kernel.org
> Subject: No resync
> 
> Is there a way to  force assemble a stopped array that has too many
> failed devices, while disabling the resync that would normally occur?

	Well, of course if the array has too few members to start (even
after the --force), then it won't start and thus won't recync, but assuming
one has enough targets to assemble and run the array, I believe
--asume-clean will do what you want.  It's in the man page.

