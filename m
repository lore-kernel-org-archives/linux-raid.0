From: David Brown <david.brown@hesbynett.no>
Subject: Re: question about the best suited RAID level/layout
Date: Fri, 05 Jul 2013 13:10:49 +0200
Message-ID: <51D6A9B9.9080908@hesbynett.no>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372961877.8716.43.camel@heisenberg.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/07/13 20:17, Christoph Anton Mitterer wrote:
> Hi.
> 
> I'm setting up a 5-bay NAS (based on a QNAP device), with my personal
> Debian on it, currently using only 4 devices though
> The focus is absolutely on data security/resilience,... and not at all
> on performance.
> 

I apologise if this is preaching to the converted.  When you are
concerned about data resilience, RAID is only part of the answer - I
just want to make sure you have considered everything else.

The main benefit of RAID is availability - you don't have downtime when
a disk fails.  It also ensures that you don't lose data that is created
between backup runs.  But it is not the solution for data safety and
reliability - that is what backups are for.

You need to look at the complete picture here.  What are the risks to
your data?  Is a double disk failure /really/ the most likely failure
scenario?  Have you considered the likelihood and consequences of other
failure types?  In my experience, user error is a bigger risk to data
loss than a double disk failure - I have more often restored from backup
due to someone deleting the wrong files (or losing them due to slipping
when dragging-and-dropping) than from disk problems, even with non-raid
setups.

Raid will help if one of your disk dies, but it will not help against
fire or theft, or hardware failure on the NAS, or software failure, or
user error, or malware (if you have windows clients), or power failure,
or any one of a number of different scenarios.

So depending on your circumstances, you might get better "data
security/resilience" by putting the extra disks in a second machine at a
second location, or other mixed primary/secondary arrangements.




