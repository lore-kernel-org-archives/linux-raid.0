From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Interpreting mdstat output
Date: Tue, 5 Feb 2013 12:34:19 +0000
Message-ID: <20130205123419.GA492@nsrc.org>
References: <20130205122048.GA417@nsrc.org>
 <7952623.6.1360067441417.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7952623.6.1360067441417.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 05, 2013 at 01:30:41PM +0100, Roy Sigurd Karlsbakk wrote:
> I beleive using 22 drives in a single RAID-5 is something like BASE jumping with a large umbrella. You should at least use RAID-6, and perhaps even split up the RAID into smaller ones.

Point taken, but this is actually a large dataset which could be recreated
if necessary (i.e. it's derived from other data), and is also to be copied
to another server.
