From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Checksumming RAID?
Date: Wed, 28 Nov 2012 12:08:25 -0700
Message-ID: <952F7343-6478-417E-BA06-D1B0E36519E0@colorremedies.com>
References: <23882377.7.1354100188235.JavaMail.root@zimbra>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23882377.7.1354100188235.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 28, 2012, at 3:56 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:

> That doesn't make sense. Nearline and enterprise drives are large 7k2 drives that come in consumer and enterprise models,

Nearline drives are in between consumer and enterprise.


> Comparing "nearline" and "enterprise" like done here, is merely a comparison of small and large drives, where it's well known that the smaller (less dense) drives have less errors.

The paper I cited doesn't support this. The nearline SATA with hardware adapters to convert the interface to fibre channel. The enterprise drives were already fibre channel. The paper discusses the contribution of the adapter to checksum mismatches, but this alone doesn't account for all of the higher rate of error in nearline SATA.

Further, the paper says "There is no clear indication that disk size affects the probability of developing checksum mis- matches."

At least when it comes to URE (which is not SDC), we note that the manufacturer specs are the same for a model regardless of disk size.


Chris Murphy