From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Strange RAID-5 rebuild problem
Date: Mon, 03 Mar 2008 12:53:10 -0500
Message-ID: <47CC3B06.7050708@tmr.com>
References: <656D8E57-804D-4A63-B9CA-D3C899616F61@it-loops.com> <3816592D-B75C-4B00-B3B7-65AE3B403DB0@it-loops.com> <20080301222326.GA20435@cthulhu.home.robinhill.me.uk> <2BABB51E-7701-44D4-AD07-6394CCF77941@it-loops.com> <A5F6B52A-00BB-4096-9A8D-367F61989186@it-loops.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A5F6B52A-00BB-4096-9A8D-367F61989186@it-loops.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guntsche <mike@it-loops.com>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Guntsche wrote:
>
> On Mar 1, 2008, at 23:41, Michael Guntsche wrote:
>>
>> mdadm -w /dev/md1 works if I call it after assembling.
>> If do not call it, mount the array and start writing to it, it 
>> changes to "active"
>> but the rebuild process does not kick in.
>>
>> The only way it works for me now is.
>> * Stop the array
>> * assemble it again with mdadm --assemble --scan
>> * Call mdadm -w /dev/md1
>
> Good morning,
>
> I found out why I am seeing this behaviour but I still do not know if 
> it is a bug or not.
>
> The arrays are assembled in an initramfs. Debian's mdadm tool has a 
> script that assembles the arrays.
>
> Now this script has the following entry.
>
> # prevent writes/syncs so that resuming works (#415441). See 
> http:/bugs.debian.org/415441 for more information.
> echo 1 > /sys/module/md_mod/parameters/start_ro
>
> Changing this sysfs entry to 0, gives me the expected result if I do a 
> stop -> assemble with my 1.0 array.
> It starts reysncing and everything is ok. According to the replies in 
> this bug, setting start_ro to 1 should NOT stop the automatic resync 
> after a write to it, but this seems to have changed now.
> So, is this a change in behaviour or is it a bug. If it is the former, 
> I probably need to talk with the debian guys about it, if it is a bug 
> I wait for a fix and comment the entry in the mean time.

Note that if you don't start_ro I don't believe you will be able to use 
the resume feature. The use of -w option would seem safer. I haven't 
looked at the patch Neil submitted to start rebuild/reshape at the first 
write, the logic seems correct to work with resume, nothing should start 
until a user write.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


