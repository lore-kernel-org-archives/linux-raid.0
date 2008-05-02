From: berk walker <berk@panix.com>
Subject: Re: Sleeping hard drives in an array?
Date: Fri, 02 May 2008 18:11:26 -0400
Message-ID: <481B918E.4@panix.com>
References: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com> <481B836E.6040208@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <481B836E.6040208@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Greg Cormier <gcormier@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Greg Cormier wrote:
>> Is it possible to sleep hard drives in an array?
>>
>> I have a HTPC at home that's on 24x7. It does all my torrenting as
>> well, and is mainly a media server.
>>
>> Can I sleep the drives in my RAID5 array while it's not being used?
>> It's an XFS partition.
>>
>> I have each drive set as
>>
>> hdparm -S240 /dev/sdX
>>
>> But I'm fairly sure they are not spinning down :( Is there some
>> activity mdadm is doing in the background?
>>
>> These things are probably idle 22 hours of the day.
>>   
> 
> I have several very similar systems, and I note that on one the disk 
> light blinks every five sec or so, while the others don't do that. The 
> one that blinks is the only one running LVM, all the others were 
> partitioned by hand. Does that apply to your system, LVM in use?
> 
Geez!!  pardon me if I don't either "get it" or am unable to communicate 
about "it".  Those thinking that I'm un-necessarily repeating myself - 
email your flames and I will be gone from here for a few months.

Put / [and whatever ELSE that needs to be mounted] on a USB drive.  I 
recently got a 2Gb drive for pocket change!!

Learn, or borrow someone who knows how - scripts. I don't think that you 
would give a darn if a ram-drive didn't "spin-down".  So PUT what can 
not be put to sleep on something that doesn't have mechanical wear!!!

Your system can be set up to WAKE up with everything mounted and ready 
to go on ANY trigger/situation that YOU want - except the states need to 
be either on or off... there are lots of states that newer 'puters 
monitor.  I'm sorry but THIS is not rocket science.

NOW!!  YOU FAILED TO RESPOND!!  To my earlier response to you.  Please 
allow me to ax you again....  WHY do you want spin-down?  HMMM
	Less noise-	- buy new drives
	Less elect. co$t - If they aren't seeking, draw is LOW
	Less wear on the drives - I have never had a drive mfg respond 				to 
my questions about this.  My [totally personal] view 			on this is if 
you're shutting down for a few hr., you 				will lose, weeks will win.

As a FINAL note here - Somehow I do not know WHAT compubox that you are 
using, IF you are using linux/unix/bsd, and WHAT level your 
make/compiler/etc are at.  This particular forum has SEVERAL really 
talanted and experienced people on here.  The only reason which I could 
point at might be that you seem to be clueless - which is a different 
forum.  :)

If I have caused yellow dribble and you wish to directly hammer me .. my 
name is "berk"  hehe.. and my email provider is "panix".. of course +".com.

If you cause me to be flooded w/spam....................[I know, it's a 
public forum].

b-
