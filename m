From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Western Digital RE3
Date: Thu, 28 May 2009 09:24:12 -0400
Message-ID: <4A1E907C.5000607@tmr.com>
References: <b9f8dfb10905250717p75c04aefqe8bff6776c1d3eda@mail.gmail.com> <4A1AEF7C.7020201@sauce.co.nz> <3ECBDC05781B3D48ABD520A01ABF2F9B2C64BED645@SE-EX008.groupinfra.com> <4A1DCCE8.9040301@tmr.com> <3ECBDC05781B3D48ABD520A01ABF2F9B2C77213D8A@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040101040203040706010307"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B2C77213D8A@SE-EX008.groupinfra.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Henry, Andrew" <andrew.henry@logica.com>
Cc: Richard Scobie <richard@sauce.co.nz>, "MOgWai46[Saurceful of Secrets]" <street41@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040101040203040706010307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Henry, Andrew wrote:
>> I'm told that my script to keep "FreeAgent" USB external drives from
>> doing that also works with similar other drives which want to sleep. I
>> have *not* verified that (having none and no time), but if you want the
>> script to try on your own, I think I posted it here, or could put it up
>> on request.
>>
>> --
>> bill davidsen <davidsen@tmr.com>
>>   CTO TMR Associates, Inc
>>     
>
> That would be great!  I would definitely like to have a script that keeps drives alive.  Can you send it privately (keep the list archive smaller) or put it on the net?
>   

This is the version I posted, I've played with some extra features, but 
since you may want to modify it, simple is best. It's small enough to 
just send.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.



--------------040101040203040706010307
Content-Type: text/plain;
 name="FreeAgentFix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="FreeAgentFix"

#!/bin/bash
# FreeAgentFix 1.4 2008-02-17 19:45:13-05 root Stable
#================================================================
# FreeAgentFix - fix "Free Agent" USB drives going off line in Linux
#   Author: davidsen@tmr.com
# Based on discussions in LKML and similar lists
#   brings the drive online
#   clears standby
#   Tells the kernel to allow restart

# sanity check
if [ $# -lt 1 ]; then
  echo "FreeAgentFix v1.4 - keeps \"Free Agent\" drives online in Linux"
  echo
  echo "Usage:"
  echo "  ./FreeAgentFix sdX"
  echo
  echo "Where \"X\" is the drive letter assigned when the drive is connected"
  echo
  echo "Plug in the drive, see what device name is assigned to the drive"
  echo "using \"dmesg | tail -10\" or similar"
  echo "run the script with the drive name only (without /dev/)"
  echo
  echo

  # this should be made executable (chmod +x FreeAgentFix) but if
  # someone sources it, don't mess them up
  fn=${0##*/}
  if [ "$fn" == "FreeAgentFix" ]; then
    exit; else
    return
  fi
fi

disk=$1

bash -v <<XX
# Start the drive
sdparm --command=start /dev/${disk}
# Clear the standby
sdparm --clear STANDBY -6 /dev/${disk}
# Allow restart
cd /sys/block/${disk}/device/scsi_disk*
if [ -f allow_restart ]; then
 echo 1 >allow_restart
fi

--------------040101040203040706010307--
