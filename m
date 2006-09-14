From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: access *exisiting* array from knoppix
Date: Thu, 14 Sep 2006 18:58:21 +0300
Message-ID: <5b170a7d0609140858gef68e69taaa8e4930f87c5fd@mail.gmail.com>
References: <200609121352.08834.Dexter.Filmore@gmx.de>
	 <Pine.LNX.4.64.0609120928560.19418@p34.internal.lan>
	 <200609121601.17783.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609121601.17783.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > mdadm --assemble /dev/md0 /dev/hda1 /dev/hdb1 # i think, man mdadm
>
> Not what I meant: there already exists an array on a file server that was
> created from the server os, I want to boot that server from knoppix instead
> and access the array.
>

exactly what --assemble does. looks at disks, finds raid components,
assembles an array out of them (meaning, tells the kernel where to
find the pieces) and starts it.

no? did you try? read the manual?
