From: "John Stoffel" <john@stoffel.org>
Subject: Re: md0: invalid bitmap page request: 249 (> 223)
Date: Fri, 13 Apr 2007 13:38:06 -0400
Message-ID: <17951.49150.877081.629155@smtp.charter.net>
References: <17950.22648.37421.148022@smtp.charter.net>
	<461E5E3F.4070108@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <461E5E3F.4070108@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Bill" == Bill Davidsen <davidsen@tmr.com> writes:

>> Is there anyway I can interrupt the command I used:
>> 
>> mdadm --grow /dev/md0 --size=#####
>> 
>> which I know now I should have used the --size=max paramter instead,
>> but it wasn't in the man page or the online help.  Oh well...
>> 
>> I tried removing the bitmap with:
>> 
>> mdadm --grow /dev/md0 --bitmap=none
>> 
>> but of course it won't let me do that.  Would I have to hot-fail one
>> of my disks to interrupt the re-sync, so I can remove the bitmap, so I
>> can then grow the RAID1 to the max volume size?

Bill> I think you could interrupt it by echoing 'idle' to the
Bill> sync_action, but I personally wouldn't do that, since there are
Bill> indications of some problem already, and doing another unusual
Bill> thing is not prudent.

Doing an 'echo idle > sync_action' was not a good idea.  The system
was not happy with me.  This I consider to be a bug, since the MD
system should just ignore commands it can't handle at a point.  

So you'd need to do the echo first, then a cat to check the status.  

Bill> I doubt you problems are caused by specifying the size rather
Bill> than using "max," unless you got it wrong, in which case I
Bill> wouldn't guess what is going to happen.

It looks like it's a known issue with bitmaps that Neil hasn't fixed
yet.  Oh well.  Now my problems seem to be bad blocks on the new
disk.  Sigh...  *grin*  

But I'm now running on the new disks ok and enjoying the extra disk
space.


John
