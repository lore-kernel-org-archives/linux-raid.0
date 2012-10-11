From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: task xfssyncd blocked while raid5 was in recovery
Date: Thu, 11 Oct 2012 06:01:58 -0500
Message-ID: <5076A726.3070002@hardwarefreak.com>
References: <CACY-59dr2Gy5XgddD01yy+c5ktCgYvOdU9w-VX8GK27bvbbgRA@mail.gmail.com> <507561EB.1050308@hardwarefreak.com> <alpine.DEB.2.00.1210110810210.21297@uplift.swm.pp.se>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1210110810210.21297@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/11/2012 1:12 AM, Mikael Abrahamsson wrote:
> On Wed, 10 Oct 2012, Stan Hoeppner wrote:
> 
>> Precisely what it says.  It doesn't tell you WHY it was blocked, as it
>> can't know.  The fact that your md array was in recovery and having
>> problems with one of the member drives is a good reason for xfssyncd
>> to block.
> 
> Doesn't he still have 3 good drives? So since sdb was failed, there
> would be no reason for sdb to cause blocking or writes to the (now
> degraded) raid5? OP said he saw write IO errors to the array (?), which
> I thought was strange.

I think the more important question is, why was the OP writing to a
filesystem on a small RAID5 array while it was doing a rebuild?  My
assumption here was that the seek load due to the rebuild was what
caused xfssyncd to block.  IO Load is a common cause of this particular
kernel message when it relates to XFS.

Note this msg is not an error, but informational, thus the "INFO: " tag.
 This is why you have the option to turn off the message.  Also note
there are many conditions that will prompt this "blocked for 120s"
kernel message, and that this message is not unique to XFS.  Point of
fact, Google for "blocked for more than 120 seconds" and no results on
the first page relate to XFS.

-- 
Stan

