From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: access *exisiting* array from knoppix
Date: Thu, 14 Sep 2006 18:06:15 +0200
Message-ID: <200609141806.15236.Dexter.Filmore@gmx.de>
References: <200609121352.08834.Dexter.Filmore@gmx.de> <200609121601.17783.Dexter.Filmore@gmx.de> <5b170a7d0609140858gef68e69taaa8e4930f87c5fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b170a7d0609140858gef68e69taaa8e4930f87c5fd@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Tuomas Leikola <tuomas.leikola@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Donnerstag, 14. September 2006 17:58 schrieb Tuomas Leikola:
> > > mdadm --assemble /dev/md0 /dev/hda1 /dev/hdb1 # i think, man mdadm
> >
> > Not what I meant: there already exists an array on a file server that was
> > created from the server os, I want to boot that server from knoppix
> > instead and access the array.
>
> exactly what --assemble does. looks at disks, finds raid components,
> assembles an array out of them (meaning, tells the kernel where to
> find the pieces) and starts it.
>
> no? did you try? read the manual?

How about you read the rest of the thread, wisecracker?


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
