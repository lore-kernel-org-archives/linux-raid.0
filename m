From: "Brian Jackson" <brian-lists@mdrx.com>
Subject: Re: Cluster Aware MD Driver
Date: Sat, 04 Jan 2003 15:06:13 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030104210613.28211.qmail@escalade.vistahp.com>
References: <200301041016.10224.vittorio.ballestra@infogestnet.it>
            <20030104164314.26621.qmail@escalade.vistahp.com>
            <3E173241.2040301@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E173241.2040301@mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: opengfs-users@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steven Dake writes: 

> Brian, 
> 
> The way to fix this problem is to enable the MD layer and MD tools to be 
> cluster aware.  I hope sometime before March 03 to have this functionality 
> implemented in 2.4 and mdadm 1.0.1. 
> 
> While I have not spent a ton of time thinking about it, I'll share what 
> I'm thinking in case someone else wants to get a jump start since I wont 
> have time until Feb to start working on it.

I haven't looked at their implementation in depth, but I know EVMS has the 
beginnings of this. Might be worth a peek. 

> 
> What I am thinking of doing is making one node in a cluster the master, 
> and all other nodes nonmasters.  The master is responsible for commiting 
> superblock and resync changes to disk.  The other nodes are responsible 
> for updating their status if any one node changes state. 
> 
> During startup, a userland daemon runs which opens a TCP port.  Then the 
> daemon attempts to connect to a list of other servers in a configuration 
> file (/etc/clusterips).  On each connection, a master of the cluster is 
> elected by an election algortihm.  Once the daemon makes connections, it 
> culls its file descriptor list such that it only has one connection per 
> server to each other server.  Whenever a state change occurs (raid set 
> faulty, raid array failed, raid hot added, raid hot removed, raid start, 
> raid stop, etc) the state change is transmitted via the server to all 
> other server nodes.  When the server receives a state change message, it 
> will handle appropriately by using the md ioctls to update its internal 
> state.  There are more complications, such as heartbeating to detect dead 
> nodes, etc.  All of this keeps the arrays in sync across the entire 
> cluster.  The big changes here are to the mdadm package to use the local 
> server to execute operations and to create a server which processes the 
> state changes and executes the appropriate MD layer ioctls.

One thing you might want to think about is that most people who are looking 
at a cluster capable raid are already going to have some sort of cluster 
management software. It might be useful to use the transports available. 
Maybe a plugin system that uses what you were saying as the default method, 
but can also use a plugin written to take advantage of an existing cluster 
management system. Just an idea. 

> 
> The question you might be asking is, how do you protect from each server 
> overwritting similiar data such as the superblock or resync data.  The 
> trick is to add an ioctl to the MD layer that turns writes on or off. 
> During master election above, the master will turn its writes on.  All 
> non-masters will turn their writes off before any RAID arrays are started. 
>  Also, resyncs have to be communicated across the cluster such that 
> /proc/mdstat displays correct information so I believe an ioctl will have 
> to be added to indicate this and allow resync from a specific spot in case 
> the current master dies in a resync.  The changes to the MD layer should 
> be fairly minimal and noninvasive and also work well for non-cluster 
> configurations.  The writes will default to on to ensure that non-clusters 
> work properly even with autostart.

Maybe the ability to write or not could be a mdadm switch. Something like: 

mdadm -A --non-master 

that would keep the changes to the MD drivers to a minimum(I think, but I 
may be thinking the wrong way), but require manual intervention if the 
master were to die(or at least some sort of outside intervention). 

> 
> The only downside of this approach is that RAID autostart can no longer be 
> used.  The only solution to supporting that feature for clusters is to 
> write all of the above userspace code into the kernel which would be a big 
> pain and likely not accepted into the mainline.

That won't be a big deal for most HA/LB type clusters. I think it will 
matter more to the HPC crowd though(they might be using GFS as /). Even then 
they can probably get most of the functionality they need with early 
userspace. 

> 
> Thanks
> -steve

 --Brian Jackson 

P.S. I have some other ideas about this I might send later on. Also LMB from 
the Linux-ha list might be interested too. I think he wrote some patches 
that sort of made MD work in a cluster. 

> 
> Brian Jackson wrote: 
> 
>> At the moment if one node goes down, the rest of the nodes will continue 
>> to run as expected. The only single point of failure from a node point of 
>> view is the lock server. Dominik is working on integrating the OpenDLM to 
>> get rid of that single point of failure. If one disk in the shared 
>> storage dies, that will bring you down. I have tried to stack pool on top 
>> of software raid, but the MD driver doesn't play well with clusters so 
>> that won't work. We are trying to figure out a way to fix this, but when 
>> GFS was originally designed the pool driver(that does GFS's volume 
>> management) only had stripping(raid0). I hope this answers your 
>> questions.
>> --Brian Jackson
>> P.S. I am not sure, but it sounds like you have some misconception about 
>> how OpenGFS works. It does not use the disks on your nodes. It uses some 
>> kind of shared storage.
>> Vittorio Ballestra writes: 
>> 
>>> Escuse me if this is a stupid or repetead question, I've searched into 
>>> the docs (?) and the mailinglists but I'm not able to understand if 
>>> openGFS has some sort of fault-tollerance.
>>> This are my doubts :
>>> What happens if one host is down or one disk on one host is down ? Will 
>>> the entire openGFS filesystem be down ? If one disk is broken and its 
>>> content corrupted, will the whole openGFS be corrupted ?
>>> If openGFS is not supporting any kind of fault-tollerance, can one use 
>>> raid disks on each node ?
>>> Thanks,
>>>     V 
>>> 
>>> -------------------------------------------------------
>>> This sf.net email is sponsored by:ThinkGeek
>>> Welcome to geek heaven.
>>> http://thinkgeek.com/sf
>>> _______________________________________________
>>> Opengfs-users mailing list
>>> Opengfs-users@lists.sourceforge.net
>>> https://lists.sourceforge.net/lists/listinfo/opengfs-users
>>  
>> 
>>  
>> 
>> -------------------------------------------------------
>> This sf.net email is sponsored by:ThinkGeek
>> Welcome to geek heaven.
>> http://thinkgeek.com/sf
>> _______________________________________________
>> Opengfs-users mailing list
>> Opengfs-users@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/opengfs-users 
>> 
>>  
>> 
>  
> 
> 
> -------------------------------------------------------
> This sf.net email is sponsored by:ThinkGeek
> Welcome to geek heaven.
> http://thinkgeek.com/sf
> _______________________________________________
> Opengfs-users mailing list
> Opengfs-users@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/opengfs-users
 
