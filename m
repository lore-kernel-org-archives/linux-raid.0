From: joystick <joystick@shiftmail.org>
Subject: Re: recommending RAID6 over RAID5 when doing mdadm --create
Date: Mon, 11 Nov 2013 12:37:47 +0100
Message-ID: <5280C18B.9060105@shiftmail.org>
References: <alpine.DEB.2.02.1311110841340.26054@uplift.swm.pp.se> <52809BC5.2010605@hardwarefreak.com> <CAGA4a+E-QXnsubz+TysnqjoHU1813FQcZhRSL8qfiB0=FySAHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGA4a+E-QXnsubz+TysnqjoHU1813FQcZhRSL8qfiB0=FySAHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tommy Apel <tommyapeldk@gmail.com>
Cc: stan@hardwarefreak.com, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/11/2013 10:37, Tommy Apel wrote:
> 2013/11/11 Stan Hoeppner <stan@hardwarefreak.com>:
>> On 11/11/2013 1:44 AM, Mikael Abrahamsson wrote:
>>
>>> I believe this has been discussed before, but I would like to bring it
>>> up again.
>>>
>>> I would like to see mdadm recommend RAID6 over RAID6 when using
>>> component drives that are 500GB or larger and ask if the user is really
>>> sure about using RAID5, plus a pointer to a webpage on the wiki
>>> informing the user about the trouble with RAID5 on large volumes with
>>> consumer or prosumer drives.
>>>
>>> I am willing to contribute text to the webpage being pointed to.
>> Wikis change to regularly, too easily.  Networks can be down at times,
>> often the worst times.  See Murphy's Law.
>>
>> It would be better to put this information in mdadm(8) and refer the
>> user there.
>>
>> --
>> Stan
> Good point Stan,
> maybe even "are you sure you really want to do this? (see mdadm(8) for
> further information)" when creating the array
>

Currently raid6 does not have an implementation for shortcut rmw, so 
there is at least one reason to do raid5, and it's not easy to guess for 
the average user.

Putting a yes/no confirmation seems exxagerate to me, that would be on 
the same warning level of "partition contains metadata of an existing 
array", which is a MUCH more serious error message.

The user would be then tempted to use "yes" in front of mdadm create (*) 
when copy-pasting lines, and then possibly blow up an existing RAID 
without chance to see the confirmation prompt.

(*) I prepare mdadm create lines on a text files and then paste them on 
systems, usually many create commands together, I think most people do 
the same, because mdadm create lines are too complex to be typed 
in-place. If the create commands are to be scripted for any reason, it's 
worse, in this case almost certainly the user would use "yes".

I think a simple warning message without confirmation prompt is fair. 
The user can repeat the command with raid6 after reading.

Regards
J.

