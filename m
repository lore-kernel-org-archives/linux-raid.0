From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Cluster Aware MD Driver
Date: Tue, 7 Jan 2003 06:54:55 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D4F9@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Brian Jackson' <brian-lists@mdrx.com>, Steven Dake <sdake@mvista.com>
Cc: opengfs-users@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I also had a couple of comments below.  My .02.

Andy

-----Original Message-----
From: Brian Jackson
Sent: Saturday, January 04, 2003 4:06 PM
To: Steven Dake
Cc: opengfs-users@lists.sourceforge.net; linux-raid@vger.kernel.org
Subject: Re: Cluster Aware MD Driver

[...]
One thing you might want to think about is that most people who are looking 
at a cluster capable raid are already going to have some sort of cluster 
management software. It might be useful to use the transports available. 
Maybe a plugin system that uses what you were saying as the default method, 
but can also use a plugin written to take advantage of an existing cluster 
management system. Just an idea. 

[Andy] I would agree, but state this more strongly, in that utilizing the
existing 
cluster management software would be a requirement for most of these
customers.  
Things like the heartbeat, network transport, election process, and
master/slave
relationships would be things that would come with that software, and need
to be 
administered from a common interface in the cluster, so using a plugin or
dynamic 
library for these functions sounds like a good approach.

> 
> The question you might be asking is, how do you protect from each server 
> overwritting similiar data such as the superblock or resync data.  
[...]
>              The writes will default to on to ensure that non-clusters 
> work properly even with autostart.

Maybe the ability to write or not could be a mdadm switch. Something like: 

mdadm -A --non-master 

that would keep the changes to the MD drivers to a minimum(I think, but I 
may be thinking the wrong way), but require manual intervention if the 
master were to die(or at least some sort of outside intervention). 

[Andy] The outside intervention would be from the cluster management
software, since
I don't think manual intervention would do.  If there were an API to toggle
this, the 
cluster management software would be able to change who the master was if
the master 
node went down.  

[...]
