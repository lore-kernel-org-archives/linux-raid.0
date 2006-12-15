From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Fri, 15 Dec 2006 15:11:49 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612151504360.3466@compserv1>
References: <Pine.GSO.4.53.0612122217360.22195@compserv1> <200612150747.02708.edt@aei.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200612150747.02708.edt@aei.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Wednesday 13 December 2006 12:47, Nikolai Joukov wrote:
> > We have designed a new stackable file system that we called RAIF:
> > Redundant Array of Independent Filesystems
>
> Do you have a function similar to an an EMC cloneset?   Basicily a cloneset
> tracks what has changed in both the source and target luns (drives).  When one
> updates the cloneset the target is made identical to the source.  Its a great
> way to do backups.  Its an important feature to be able to write to the target drives.
> I would love to see this working at a filesystem level.

Well, if you mount RAIF over your file system and a for-backups file
system, RAIF can replicate the files on both of them automatically.  I
guess that's what you need.

Nikolai.
---------------------
Nikolai Joukov, Ph.D.
Filesystems and Storage Laboratory
Stony Brook University
