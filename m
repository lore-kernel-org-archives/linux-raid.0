From: AndyLiebman@aol.com
Subject: Re: Please Confirm I'm Solving Problem Correctly!
Date: Thu, 4 Mar 2004 08:36:03 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <be.6b4d003.2d788ac3@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, bugzilla@watkins-home.com
List-Id: linux-raid.ids

>In a message dated 3/3/2004 11:11:54 PM Eastern Standard Time, 
bugzilla@watkins->home.com writes:

>One failed drive should NOT cause data corruption!  The array should
>continue just fine.  In most cases you may not know a disk has failed,
>unless you notice a decrease in performance.
>
>I am not an expert, so wait for someone like Neil Brown to respond before
>you take any chances with your data.
>
>Your "fail, remove and add" is correct, but only after you assemble the
>array.  I would verify the data first, before doing the fail.
>
>Corruption?  I have 2 guesses.
>1. a bug in the RAID software.
>2. somehow the bad disk was returning bad data instead of giving a read
>error.  The RAID software did not detect a read error, so it did not fail
>the drive.
>
>Guy

I was looking back at some old comments from Neil Brown regarding another 
problem I once had.  I'm confused about whether I need to start the array with 
RUN before I "fail/remove" the bad drive? 

Right now, if I try to assemble the array with 

'mdadm -Av /dev/md6 --uuid=[uuid string] /dev/sd*' 

I get back a message: 
mdadm: /dev/md6 assembled from 4 drives - need all 5 to start it (use --run 
to insist)

If I 'cat /proc/mdstat' the array shows up but is "inactive". Which I guess 
means it isn't "started". But it seems to be "assembled". 

In the past, Neil told me to do just what it says, use "run".  Meaning, 
'mdadm -Av --run --uuid=[uuid string] /dev/sd*' 

Does the array in fact need to be "started" (with run, if necessary) before I 
can "fail" and "remove" the faulty drive? I guess that's my question? I 
thought it only needed to be "assembled".  

Hope I can get a good answer to this soon! Thanks. 

Andy Liebman
