From: "John Stoffel" <john@stoffel.org>
Subject: Re: Real Time Mirroring of a NAS
Date: Fri, 7 Apr 2006 09:25:24 -0400
Message-ID: <17462.26692.193774.288778@smtp.charter.net>
References: <44364336.7060704@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44364336.7060704@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


andy> I'm looking for a way to create a real-time mirror of a NAS. In
andy> other words, say I have a 5.5 TB NAS (3ware 16-drive array,
andy> RAID-5, 500 GB drives). I want to mirror it in real time to a
andy> completely separate 5.5 TB NAS. RSYNCing in the background is
andy> not an option. The two NAS boxes need to hold identical data at
andy> all times. It is NOT necessary that the data be accessed from
andy> both NAS boxes simultaneously. One is simply a backup of the
andy> other.

How much data loss can you stand?  Or more accurately, how much lag in
copying data between the arrays can you stand for your Disaster
recovery issues?  How far apart are the two systems?  Is the setup
write intensive, or read intensive?

Why is rsync not an option?  Not upto date enough?  *grin*  

One option might be to use inotify to watch filesystem A and to copy
data that changes to filesystem B as quickly as possible.  

andy> I guess one option might be to use Redhat's Global File System
andy> (GFS).  Although there seems to be an 8TB limit for a GFS
andy> filesystem, which could be an issue down the road.

How large are you planning on growing your filesystem?  Why can't it
be split?  What are your assumptions?   

andy> But would the following approach work:

andy> Can I export NAS B as a SAN or ISCSI target, connect the two
andy> machines with, say, mryinet cards or 10 GbE TOE cards, mount the
andy> NAS B volume on NAS A, and create a RAID-1 mirror of the two
andy> volumes? Is this kind of thing done?

I guess I'd look into mirroring the underlying disk subsystems and
then putting the NAS on top of that.  If the NAS box goes down, you
can then just fire up NAS on the backup server and continue. 

Mostly, I don't understand what problem you're trying to solve, so I
can't offer good suggestions because the solution changes depending on
assumptions.  

I already assume you don't have tons of money to spend here.  *grin*

John
