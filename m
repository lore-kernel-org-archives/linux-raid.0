From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: raid10 recovery assistance requested
Date: Mon, 23 Sep 2013 15:19:51 +1000
Message-ID: <523FCF77.9080707@websitemanagers.com.au>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com> <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com> <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com> <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com> <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com> <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com> <523FAD81.9070005@turmel.org> <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com> <523FB511.5070001@turmel.org> <CA+dwz-31yG3Y4xzmUoiMNtLw=q1pE_GTyNqSk5WBAsGDCGT9iw@mail.gmail.com> <523FBAB2.7070506@turmel.org> <CA+dwz-2qqYbL1uFmL+vnS=ht6ZHxMDkRRBUYPz0KFQZNZke
 K-A@mail.gmail.com> <523FBFAA.3050705@turmel.org> <CA+dwz-2CMaoquRso8d=FZ1X5cEWE0vz7ceR6zhwzR2xM=1FM9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-2CMaoquRso8d=FZ1X5cEWE0vz7ceR6zhwzR2xM=1FM9A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Gomboc <dave_gomboc@acm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/09/13 14:55, Dave Gomboc wrote:
> root@sysresccd /mnt % mount -o ro /dev/mapper/teramooch-srv /mnt/srv
> NTFS signature is missing.
> Failed to mount '/dev/mapper/teramooch-srv': Invalid argument
> The device '/dev/mapper/teramooch-srv' doesn't seem to have a valid NTFS.
> Maybe the wrong device is used? Or the whole disk instead of a
> partition (e.g. /dev/sda, not /dev/sda1)? Or the other way around?
>
> It should be ext3, not NTFS.

Try:
mount -o ro -t ext3 /dev/mapper/teramooch-srv /mnt/srv
This just specifies it is ext3 format, but will probably still fail... 
check dmesg for details, but hopefully the next step will fix it.


If that fails, take a look at:
fsck.ext3 -n /dev/mapper/teramooch-srv
(Which should do a read-only check, if there are not too many changes, 
re-run with -y). Worst case, if the fsck destroys the data, you can 
re-copy the entire array from the original and try again.

Hope that helps...

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
