From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: What SATA controller for software raid and/or lvm?
Date: Sun, 18 Jan 2004 23:29:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040118212933.GB3763@hvs.envisage.co.za>
References: <1074459283.2532.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1074459283.2532.50.camel@localhost.localdomain>
To: Ming Zhang <mingz@ele.uri.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 18, 2004 at 03:54:44PM -0500, Ming Zhang wrote:
> Hi, I want to setup a software raid and lvm configuration with 2-4TB raw
> disk space. I wonder if you can give me some suggestions on what kind of
> sata controllers are friendly to my purpose? :)

Those supported properly in the kernel :)

At present I'm using the onboard Via & Promise (20378) for SATA + (evms)
software RAID, but there are others that have different views on which
controller(s) to use.

Hendrik
