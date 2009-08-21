From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: linux disk access when idle
Date: Fri, 21 Aug 2009 12:31:13 -0500
Message-ID: <20090821173113.GC18915@sewage>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A6F9E25@SE-EX008.groupinfra.com> <371021.65217.qm@web51309.mail.re2.yahoo.com> <D27CA15508148C428A25104ADEFAAC8104529F5F@CORPUSMX50C.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D27CA15508148C428A25104ADEFAAC8104529F5F@CORPUSMX50C.corp.emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Foster_Brian@emc.com
Cc: Jon@eHardcastle.com, linux-raid@vger.kernel.org, andrew.henry@logica.com
List-Id: linux-raid.ids

On Fri, Aug 21, 2009 at 12:35:19PM -0400, Foster_Brian@emc.com wrote:
> > There is some for of flag you can apply to see write requests and the
> > application that is doing them.......?
> > 
> 
> You might find this useful:
> 
> echo 1 > /proc/sys/vm/block_dump
> 
> Then watch your syslog files...

Thank you.  That along with Ric Wheeler's suggestion of blktrace
ought to help me get to the bottom of this.

Thanks again!
Matt

