From: Mark Bellon <mbellon@mvista.com>
Subject: Re: Question about fault-tolerant redundant disk reading
Date: Wed, 31 Mar 2004 08:38:01 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406AE5D9.7000507@mvista.com>
References: <200403301221.54747.jaf@lcsaudio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200403301221.54747.jaf@lcsaudio.com>
To: jaf@lcsaudio.com
Cc: linux-raid@vger.kernel.org, jeffk@jdkoftinoff.com, ronb@lcsaudio.com
List-Id: linux-raid.ids

Jeremy Friesner wrote:

>Hi all,
>
>I'm trying to add some basic drive-failure tolerance into my audio playback 
>system, and I could use some advice as to the best way to go about it.
>
>Some background info:  My company is working on a high-end(ish) embedded audio 
>playback device.  It's a PowerPC-based computer-on-a-card with an external 
>SCSI connector, running Linux 2.4.  The idea is that the user will connect 
>one or more external SCSI drives to this device, then power it on, and our 
>software will automount any ext3 partitions it finds on these drives, look 
>for audio files in the partitions, and play the audio out over a speaker.
>
>So far, so good.  But what we'd like to add is some fault tolerance -- 
>specifically, if one of the drives in the system was to fail or lose power, 
>we'd like the system to seamlessly fail-over to another drive so that the 
>music playback isn't interrupted.
>
>Some possibilities:
>
>1) Do it without RAID.  This would be my preference if it is possible, since 
>it would be the simplest for the user to set up.  Ideally all the user would 
>have to do is copy the same audio files onto several ext3-formatted drives 
>and plug them all in.  Our audio-playback program would read the files as 
>usual, but if the read() system call returned an error, we would assume that 
>the drive was toasted and would switch over to reading from the file with the 
>same name on another drive.  The only problem is that it's not clear that 
>Linux can be made to handle SCSI drive errors quickly and cleanly enough for 
>this to work... is this idea practical?  If so, what steps need to be taken 
>to obtain "quick-fail" behaviour?
>
>2) Use software RAID.  This would require more setup work and knowledge on the 
>part of the user, but it might handle drive failures more gracefully.  Is 
>software RAID capable of handling a failover promptly enough to avoid audio 
>dropouts?  (i.e. within 3-5 seconds?)
>
>3) Use a separate hardware RAID device so that the Linux card never even 
>realizes a failure occurred.  I think this would be the most reliable 
>solution, but we're trying to keep the price down and this would blow the 
>budget for a lot of our customers.
>
I've been dealing with a similar situation dealing with critical data 
collection. The hardware is definitively not low end - dual 2Gb 
FibreChannels each with a high performance disk, but the problems are 
similar.  Due to the incoming rate only a few seconds of buffering is 
available so I must be able to complete the I/O within a very small time 
frame - 3-4 seconds at most.

I had great difificulty tuning the SCSI layer and FibreChannel to get a 
worst case failure (the defaults could take over 3 minutes!) to be 
within my time frame (the 2.6 FastFail doesn't help that much either). 
This started me thinking about a non-responsive device timer for the 
RAID 1 driver - if a device took longer than I cared to deal with it 
would be marked faulty and the RAID 1 driver would move on. Now I would 
no longer care about what happens "down below"; I could fail over at the 
point I wanted and insure the necessary level of service.

In your case avoiding the worst case situation is complicated if you 
only have a single SCSI bus - a hung SCSI bus can take a very long time 
to clear and this would cause a delay on your access to all of your disks.
Still there are disk failures that a scheme like I detailed above would 
help with.

I've started playing with a prototype against the 2.4.25 version of MD 
RAID 1 but I would like to hear from the RAID community if it something 
worth exploring futher. If so, I would post my patch once it is done and 
see what everyone things.

Comments?

mark

