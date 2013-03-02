From: Phil Turmel <philip@turmel.org>
Subject: Re: Expanding array with multiple devices
Date: Sat, 02 Mar 2013 12:22:43 -0500
Message-ID: <51323563.4@turmel.org>
References: <25032068.12.1362244556592.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <25032068.12.1362244556592.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/02/2013 12:15 PM, Roy Sigurd Karlsbakk wrote:
>> On 03/02/2013 09:07 AM, Roy Sigurd Karlsbakk wrote:
>>>> While expanding an existing raid is as simple as mdadm --add, 
>>>> followed by an mdadm --grow, How would you go about this when
>>>> expanding it with multiple devices.
>>>
>>> Given a RAID-5 on /dev/sd[bcde], I'd do
>>>
>>> # mdadm --add /dev/md0 /dev/sd[fghi]
>>> # mdadm --grow --level=6 --raid-devices=8
>>> 
>>> No need to create a new RAID and then move the data.
>> 
>> You missed the bit where he states he needs to use mkfs to switch 
>> filesystem features.
> 
> Oh, sorry. Then why not start off with an identical RAID-5, move the
> data, and then expand as above? No dangling "missing" drives, just
> plain and simple.

I agree.  And the file copy to the raid5 would almost certainly run
faster than any raid6 with "missing".  Then the reshape is one operation
to both expand the drive count and switch to raid6.

Phil
