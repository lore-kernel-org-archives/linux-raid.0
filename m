From: Michael Guntsche <mike@it-loops.com>
Subject: Re: [PATCH] barrier support for other md/raid levels
Date: Sat, 19 Sep 2009 10:58:30 +0200
Message-ID: <20090919085830.GA84671@trillian.comsick.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>For what it's worth, I use XFS on one of my arrays, and whenever
>mounting it, I get this error:
>
>[ 2212.567725] Filesystem "dm-0": Disabling barriers, trial barrier
>write failed
>
>So I guess you could use XFS to run your tests.

Just FYI, starting with 2.6.30 or 31-rcx you no longer get that message
on a xfs->lvm->raid-5 setup. I am not sure if this is because lvm
says it supports barriers or an XFS issue.

This does not seem to be an uncommon setup so getting this working in
the long run would be nice.

Kind regards,
Michael
