From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: Hardware versus Software
Date: Wed, 19 May 2004 18:02:27 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405191759380.14297-100000@sweetums.bluetronic.net>
References: <1084996982.4948.198.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1084996982.4948.198.camel@localhost.localdomain>
To: Ming Zhang <mingz@ele.uri.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 19 May 2004, Ming Zhang wrote:
>is there any support from linux that can do this hot swappable a little
>easier?

It's not the kernel's fault.  Not entirely... SCSI will let you hot plug
with little trouble.  IDE is a different problem.

The real problem is the system hardware.  Aside from SATA, I don't know
of any MB that openly supports hot plugging of drives without some risk of
Real Trouble (tm).

--Ricky


