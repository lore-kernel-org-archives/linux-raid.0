From: Jeremy Friesner <jaf@lcsaudio.com>
Subject: Question about fault-tolerant redundant disk reading
Date: Tue, 30 Mar 2004 12:21:54 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403301221.54747.jaf@lcsaudio.com>
Reply-To: jaf@lcsaudio.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: jeffk@jdkoftinoff.com, ronb@lcsaudio.com
List-Id: linux-raid.ids

Hi all,

I'm trying to add some basic drive-failure tolerance into my audio playback 
system, and I could use some advice as to the best way to go about it.

Some background info:  My company is working on a high-end(ish) embedded audio 
playback device.  It's a PowerPC-based computer-on-a-card with an external 
SCSI connector, running Linux 2.4.  The idea is that the user will connect 
one or more external SCSI drives to this device, then power it on, and our 
software will automount any ext3 partitions it finds on these drives, look 
for audio files in the partitions, and play the audio out over a speaker.

So far, so good.  But what we'd like to add is some fault tolerance -- 
specifically, if one of the drives in the system was to fail or lose power, 
we'd like the system to seamlessly fail-over to another drive so that the 
music playback isn't interrupted.

Some possibilities:

1) Do it without RAID.  This would be my preference if it is possible, since 
it would be the simplest for the user to set up.  Ideally all the user would 
have to do is copy the same audio files onto several ext3-formatted drives 
and plug them all in.  Our audio-playback program would read the files as 
usual, but if the read() system call returned an error, we would assume that 
the drive was toasted and would switch over to reading from the file with the 
same name on another drive.  The only problem is that it's not clear that 
Linux can be made to handle SCSI drive errors quickly and cleanly enough for 
this to work... is this idea practical?  If so, what steps need to be taken 
to obtain "quick-fail" behaviour?

2) Use software RAID.  This would require more setup work and knowledge on the 
part of the user, but it might handle drive failures more gracefully.  Is 
software RAID capable of handling a failover promptly enough to avoid audio 
dropouts?  (i.e. within 3-5 seconds?)

3) Use a separate hardware RAID device so that the Linux card never even 
realizes a failure occurred.  I think this would be the most reliable 
solution, but we're trying to keep the price down and this would blow the 
budget for a lot of our customers.

If someone knowledgable can provide some advice, I'd be very appreciative.

Thanks,

Jeremy Friesner
Level Control Systems
jaf@lcsaudio.com

