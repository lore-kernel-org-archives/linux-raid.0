From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: more mdadm questions
Date: Wed, 1 Sep 2004 11:00:27 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16693.7979.802560.41021@cse.unsw.edu.au>
References: <1093997605.3399.34.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from rich turner on Tuesday August 31
To: rich turner <rich@storix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 31, rich@storix.com wrote:
> when mdadm queries information about the raid devices, does it simply
> get the imformation from /proc/mdstat and format it accordingly?

It also used the GET_ARRAY_INFO and GET_DISK_INFO ioctls.
It also reads the super-block for more information.

> 
> when mdadm displays information about the block devices raid devices are
> built on how does it display the name the devices? does it show the
> devfs name? does it show the mapper name if built on a logical volume?
> are these names consistent?

It hunts through /dev for a special file with the name major/minor
numbers, and uses the name of the file.

> 
> what about raid devices that were built with raidtools? does it look in
> /proc/mdstat for information?

arrays built with raidtools are indistinguishable from arrays built
with mdadm.

> 
> how does mdadm know what devices to query if they are not defined in
> /etc/mdadm/mdamd.conf with DEVICES?

You must be using debian.  The conf file should be /etc/mdadm.conf,
and is most places.

I'm not sure what the question means.  "query" in what sense?
The only devices mdadm queries are those that it has been told to
query, possibly by /etc/mdadm.conf, possible by command line args.


> 
> if devices are missing from the raid device, is there a way of knowing
> the name of the missing device without the configuration file?

I'm not sure that question means anything.  If device is missing, then
it doesn't exist.  You can add a spare that will be rebuilt.  It can
be any un-used device of the right size.

Supposing there was a way of "knowing the name of the missing device",
how would you use that information?

NeilBrown
