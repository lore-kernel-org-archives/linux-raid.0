From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Re: raid0 + raid1 question
Date: Thu, 09 Oct 2003 19:37:52 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F861B80.706@backtobasicsmgmt.com>
References: <3F84793F.6060400@siue.edu> <1065729282.10027.127.camel@localhost.localdomain> <3F85CC5B.5020107@siue.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F85CC5B.5020107@siue.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

anthony mayes wrote:

> I'm assuming the snapshot it the same size as the FS to backup.  What if 
> you don't have enough disk space to do this?
> 

Nope, otherwise it would take a lot longer than 1 minute to make a 
snapshot of a 360GB filesystem :-)

The snapshot is just a "holding area" to record the original disk 
blocks for anything that gets changed after the snapshot is created. 
It only needs to be big enough to hold the amount of data that you 
expect to change while it exists. In the case of using this do to 
backups, if you can copy the snapshot to another disk array in an 
hour, then the snapshot only needs to be big enough to hold an hour's 
worth of changes; if that hour is 3-4AM, when your system is otherwise 
idle, the snapshot can be pretty small.

If you make the snapshot and then backup the snapshot to tape, and it 
takes 6 hours to make the tape backup, obviously the snapshot would 
have to be bigger. It's not unheard of for people to make 10GB 
snapshots of 1TB filesystems and never even use all 10GB before they 
throw the snapshot away.

