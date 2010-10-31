From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: argh!
Date: Sat, 30 Oct 2010 19:07:53 -0500
Message-ID: <BA.FF.19545.163BCCC4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTikWcSYEAiqh_Adwg-h71h5y6hmEbLFttg2vRoHG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikWcSYEAiqh_Adwg-h71h5y6hmEbLFttg2vRoHG@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: 'Phil Turmel' <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Jon Hardcastle
> Sent: Saturday, October 30, 2010 5:01 PM
> To: Leslie Rhorer
> Cc: Phil Turmel; linux-raid@vger.kernel.org
> Subject: Re: argh!
> 
> Sorry to spam.. if i run
> 
> 'mdadm --assemble --scan -R'
> 
> the array assemles in an inactive state but it is suggesting i use
> force.. but I am worried about doing damage?
> 
> Also, perhaps some extra commands for thick people would be cool? i.e.
> force for things that are ideal.. like mounting an incomplete array
> but having to specifiy it twice i.e. '-F -F' for things that can do
> damage?

Assembly using --force won't do damage.  It simply will either pass or fail.
If it passes, proceed to mounting the array read-only.  If it fails, you'll
have to do more work.

