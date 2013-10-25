From: Phil Turmel <philip@turmel.org>
Subject: Re: re-assembling arrays after severe controller hardware issues...
Date: Fri, 25 Oct 2013 19:06:16 -0400
Message-ID: <526AF968.7090306@turmel.org>
References: <526AE059.8020006@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526AE059.8020006@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Maarten,

Good report.

On 10/25/2013 05:19 PM, Maarten wrote:
> 
> Hi
> 
> I suffered a coupleof (subsequent) multi-disk raid failures caused by
> hardware (not disk) issues. I now am reasonably confident the cause of
> the hardware issues has been remedied. Looking at one of the arrays I
> see differing event counters, but all close together. If I attempt
> --assemble that doesn't work, mdadm insists on only taking two of the
> six raid6 members into account.. Am I correct that an added --force will
> rectify that, or is a different course of action necessary ?

You are correct.  --force is the correct action.  You may have very
slight corruption from the data still in OS caches, but there's no help
for that.  Also use --verbose, and save the output for us in case
there's further difficulties.

> (Yes, there was a sixth member too, but I suffered a crash (kernel
> kicked a controller with 5 disks on it) during the re-adding of that one
> disk, so I have therefore deemed it unsafe to use for --assemble, so
> that one is marked and put away safely)

Yes, leave that one out.  I also recommend getting any critical backups
from the reassembled array before you attempt to add the missing drive.

HTH,

Phil

