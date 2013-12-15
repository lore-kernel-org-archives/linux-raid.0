From: Ken Drummond <linuxraid@kendrummond.com>
Subject: Re: Help with degraded array
Date: Sun, 15 Dec 2013 20:14:13 +1000
Message-ID: <52AD80F5.1080309@kendrummond.com>
References: <CAB1R3shBH5sAq6qDL4aQcxERA3mMo5UBJGTvVS20JjyW0ZyZLA@mail.gmail.com>	<52AC351E.5050709@suddenlinkmail.com>	<CAB1R3siFu3q98bT23Lz1u2uVqkxvth35pguzSdBQ7auZkJwumg@mail.gmail.com>	<52ACA2A0.4060405@suddenlinkmail.com> <CAB1R3sgU5eOh_MTtY=7ZwWwbvQV6py2dzNFku0PKzjB4-oEuRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sgU5eOh_MTtY=7ZwWwbvQV6py2dzNFku0PKzjB4-oEuRg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/12/2013 10:34 AM, Alex wrote:
> Hi,
>
>>    What I would do is run smartctl -t short /dev/sdc, then smartctl -a /dev/sdc
>> and make sure the drive was reported as PASSED and not in imminent failure. Then
>> run fsck on /dev/sdc2 (the partition reporting the I/O error on what was sda2 --
>> DO NOT fsck /dev/sdc3.
> I ran a short (which succeeded) then a long (which also succeeded)
> test on /dev/sdc.
>
> I realized that /dev/sdc2 is a non-raid partition mounted as /boot, so
> it can't be checked.
>
> This box is in a remote datacenter. Still think it's okay to boot remotely?
>
> Thanks,
> Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

  You could also try running a non destructive badblocks check on the 
partition "badblocks -nsv /dev/sdc3" and see if it fails again, it could 
be the cable rather than the disk that is at fault.  I would expect that 
a reboot would set the drive back to sda.

