From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 Shrinking array-size nearly killed the system
Date: Sun, 13 Mar 2011 09:33:45 -0400
Message-ID: <4D7CC7B9.3010207@turmel.org>
References: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com>	<AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com>	<alpine.DEB.1.10.1103120655370.7942@uplift.swm.pp.se>	<4D7B85EB.60505@turmel.org>	<AANLkTik2qk2ep7fsQPjAesnjur-0AB-Xx7EeZ5YfeCSA@mail.gmail.com>	<AANLkTikRdqZ4nAdLcUuYz17KeWb54ES_sNYzzW-u1R0x@mail.gmail.com>	<4D7BB462.5030706@turmel.org>	<AANLkTim+OwO5-w5Hhjdchp+Nj8k0zTLqqvRKfAzFgkWz@mail.gmail.com>	<4D7BD323.3040205@turmel.org> <AANLkTi=ZtxFJDtYCP62BZDg5=QyM3873eNDXZqC2c_wu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=ZtxFJDtYCP62BZDg5=QyM3873eNDXZqC2c_wu@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rory Jaffe <rsjaffe@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Rory,

On 03/13/2011 01:56 AM, Rory Jaffe wrote:
>> OK, so your new array size will be 5857612608 (1952537536 * 3) == 5586GB
>>
>> You can use an initial resize2fs to 5.4T to speed things up, as you don't really need to move items that are currently located between the 3.8T and 5.4T mark.  Then use the exact "mdadm --grow /dev/md0 --array-size=5857612608" afterwards before you fsck it.
>>
>> If that passes, do the rest.  The final resize2fs should be very quick.
>>
>> Phil
>>
> 
> One more glitch? I ran the following command, trying several different
> locations for the backup file, all of which have plenty of space and
> are not on the array.
> 
> sudo mdadm -G /dev/md/0_0 -n 4 --backup-file=/tmp/backmd
> 
> mdadm gives the message "mdadm: Need to backup 960K of critical
> section.." and it immediately returns to the command prompt without
> shrinking the array.

Are you sure its not doing the reshape?  "cat /proc/mdstat" will show whats happening in the background.

Also, check your dmesg to see if there are any explanatory messages.

Phil
