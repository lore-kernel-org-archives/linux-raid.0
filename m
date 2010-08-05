From: Ben Nemec <lists@nemebean.com>
Subject: RE: Replacing a drive in RAID 0
Date: Thu, 05 Aug 2010 09:51:00 -0500
Message-ID: <3215a34c262cfe726c66003c9ab6e025@localhost>
References: <9A.1C.11447.9316A5C4@cdptpa-omtalb.mail.rr.com>
Reply-To: lists@nemebean.com
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9A.1C.11447.9316A5C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Thu, 5 Aug 2010 01:59:02 -0500, "Leslie Rhorer" <lrhorer@satx.rr.com>
wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Ben Nemec
>> Sent: Monday, August 02, 2010 5:18 PM
>> To: linux-raid@vger.kernel.org
>> Subject: Replacing a drive in RAID 0
>> 
>> 
>> Hi,
>> 
>> I have a disk in a RAID 0 array that SMART tells me is dying, but
hasn't
>> died yet.  I have a warranty replacement on the way, and I'm wondering
if
>> there's any way to copy the data off the dying drive to the new drive
and
>> swap the RAID array to use the new one (assuming the old one lasts long
>> enough to do that, of course).  Can I just dd the entire drive over and
>> replace the bad drive?  Can the md tools do it somehow?  Maybe it's
>> impossible?  Obviously nothing on this array is irreplaceable, but it
>> would
>> save me some hassle reinstalling things if I could save it.
> 
> 	Well, yes, although one cannot guarantee there won't be any data
> loss.  Of course you will need to take the array offline, and indeed I
> recommend you take it down now - or at least remount it as read-only,
and
> don't do any writes to it until after you have the new drive in place.
> Install the new drive, and then use ddrescue to copy the contents of the
> old
> drive to the new.  Read the man page for ddrescue carefully, and take
care
> not to accidentally copy the new drive to the old.

Yeah, I actually did this last night and I double-checked that I was
copying to and from the correct drives about half a dozen times.  I used
the Ubuntu Rescue Remix that includes ddrescue to do the actual copy and
everything went perfectly, no lost data according to ddrescue, and the
array came right up once I swapped the new drive in.

Thanks again to everyone for all their help.

-Ben
