From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Need help with degraded raid 5
Date: Fri, 6 Mar 2020 16:55:10 -0600
Message-ID: <1d46e4cd-ea71-37b4-9850-b4b9b5937891@suddenlinkmail.com>
References: <CALc6PW74+m1tk4BGgyQRCcx1cU5W=DKWL1mq7EpriW6s=JajVg@mail.gmail.com>
 <CAD9gYJ+3gP+6aannsjzq=L0DsQ-dC2wj4SJfU3+n-t3pG0q3pg@mail.gmail.com>
 <5E61354C.2090901@youngman.org.uk>
 <CALc6PW6HYK_6UAtUVz4nmXF=BOwRrkt9HQFb0wpL5BM8tU9N4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALc6PW6HYK_6UAtUVz4nmXF=BOwRrkt9HQFb0wpL5BM8tU9N4w@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/06/2020 03:33 PM, William Morgan wrote:
> I tried re-add and I get the following error:
> 
> bill@bill-desk:~$ sudo mdadm /dev/md0 --re-add /dev/sdl1
> mdadm: Cannot open /dev/sdl1: Device or resource busy
> 
> sdl is not mounted, and it doesn't seem to be a device mapper issue:

  cat /proc/mdstat  and/or cat /proc/partitions

  and see if the disk was brought up as an array of its own (something like
/dev/md127, etc..), If so, simply

  sudo mdadm --stop /dev/md127

  The try you re-add again. I recently had that occur when I put in a
replacement disk for a raid1 array. Even though I just cut the plastic
anti-static bag off the brand-new drive, when I booted the system, it came up
as an array (of what I don't know). I got the same device busy and simply used
--stop on the obviously not-an-array array, The --re-add worked just fine
afterwards.

-- 
David C. Rankin, J.D.,P.E.
