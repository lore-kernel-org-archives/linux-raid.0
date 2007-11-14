From: David Greaves <david@dgreaves.com>
Subject: Re: Fwd: RAID5 Recovery
Date: Wed, 14 Nov 2007 12:59:06 +0000
Message-ID: <473AF11A.4050506@dgreaves.com>
References: <f0d815c0711131705s17f365b4kc122db98e8e27895@mail.gmail.com>	 <473AD4DA.7060801@dgreaves.com>	 <f0d815c0711140436x2ca72714ka6abee08c2bc70@mail.gmail.com> <f0d815c0711140436r40cce9b3mf7985f30be8b19e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f0d815c0711140436r40cce9b3mf7985f30be8b19e2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Cavan <neilcavan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Cavan wrote:
> Thanks for taking a look, David.
No problem.

> Kernel:
> 2.6.15-27-k7, stock for Ubuntu 6.06 LTS
> 
> mdadm:
> mdadm - v1.12.0 - 14 June 2005
OK - fairly old then. Not really worth trying to figure out why hdc got re-added
when things had gone wrong.

> You're right, earlier in /var/log/messages there's a notice that hdg
> dropped, I missed it before. I use mdadm --monitor, but I recently
> changed the target email address - I guess it didn't take properly.
> 
> As for replacing hdc, thanks for the diagnosis but it won't help: the
> drive is actually fine, as is hdg. I've replaced hdc before, only to
> have the brand new hdc show the same behaviour, and SMART says the
> drive is A-OK. There's something flaky about these PCI IDE
> controllers. I think it's new system time.
Any excuse eh? :)


> Reiserfs recovery-wise: any suggestions? A simple fsck doesn't find a
> file system superblock. Is --rebuild-sb the way to go here?
No idea, sorry. I only ever tried Reiser once and it failed. It was very hard to
get recovered so I swapped back to XFS.

Good luck on the fscking

David
