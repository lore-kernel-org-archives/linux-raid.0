From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Raid failing, which command to remove the bad drive?
Date: Sat, 03 Sep 2011 11:45:10 -0700
Message-ID: <4E6275B6.2000702@vorgon.com>
References: <4E57FE4D.5080503@vorgon.com> <20110827084535.5e64bf5c@notabene.brown> <4E5FC63A.1040206@vorgon.com> <CAEUYfyN6nfEDwgE8_eZN48UFzaJNCN2NjBpJbeQR_G01CYCgvQ@mail.gmail.com> <4E60F95C.40203@vorgon.com> <CAEUYfyPWFwyadvYC8pUTssQMpGhqEoB0aTHtM_3yb7o33M1Edw@mail.gmail.com> <20110903121723.GA6123@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110903121723.GA6123@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 9/3/2011 5:17 AM, Robin Hill wrote:
> On Sat Sep 03, 2011 at 04:35:39 -0700, Simon Matthews wrote:
>
>> On Fri, Sep 2, 2011 at 8:42 AM, Timothy D. Lenz<tlenz@vorgon.com>  wrote:
>>>
>>>>
>>>> How did you install Grub on the second drive? I have seen some
>>>> instructions on the web that would not allow the system to boot if the
>>>> first drive failed or was removed.
>>>>
>>>
>>>
>>> I think this is how I did it, at least it is what I had in my notes:
>>>
>>> grub-install /dev/sda&&  grub-install /dev/sdb
>>>
>>> And this is from my notes also. It was from an IRC chat. Don't know if it
>>> was the raid channel or the grub channel:
>>>
>>> [14:02]<Jordan_U>  Vorg: No. First, what is the output of grub-install
>>> --version?
>>> [14:02]<Vorg>    (GNU GRUB 1.98~20100115-1)
>>> [14:04]<Jordan_U>  Vorg: Ok, then run "grub-install /dev/sda&&  grub-install
>>> /dev/sdb" (where sda and sdb are the members of the array)
>>>
>>
>> Which is exactly my point. You installed grub on /dev/sdb such that it
>> would  boot off /dev/sdb. But if /dev/sda has failed, on reboot, the
>> hard drive that was /dev/sdb is now /dev/sda, but Grub is still
>> looking for its files on the non-existent /dev/sdb.
>>
> The way I do it is to run grub, then for each drive do:
>      device (hd0) /dev/sdX
>      root (hd0,0)
>      setup (hd0)
>
> That should set up each drive to boot up as the first drive.
>
> Cheers,
>      Robin


That is how I was trying to do it when I first set it up and was having 
problems with it not working. The grub people said not to do it that way 
because of a greater potential for problems.

The way I read the line I think I used, "&&" is used to put two commands 
on the same line, so it should have done both. But, If I did that from 
user vorg instead of user root, I would have needed sudo before both 
grub-install commands. I can't remember now what I did.

The second drive is teh one that died and was removed, but I guess if 
sda wasn't bootable, it could have been booting off of sdb the whole time.
