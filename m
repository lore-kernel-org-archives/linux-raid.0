From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: mdadm rebuild
Date: Mon, 09 Dec 2013 10:56:32 +1100
Message-ID: <52A50730.4030301@websitemanagers.com.au>
References: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com>	<20131209085554.262006d5@notabene.brown>	<CAJ1=nZfUBQ0_T1s3deG+HOU7BQeayibWcW8y5h5bEjFt2tvhnA@mail.gmail.com>	<20131209095328.0d39e6ad@notabene.brown>	<CA74C8FD-DBDC-428B-9645-E2DD2300EE9D@gmail.com> <20131209101752.33deb603@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131209101752.33deb603@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Hai Wu <haiwu.us@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/12/13 10:17, NeilBrown wrote:
> On Sun, 8 Dec 2013 17:03:22 -0600 Hai Wu <haiwu.us@gmail.com> wrote:
>
>> This is something I am not aware of, thanks!
>>
>> In this case, do I have to worry about cases where the new drive might not be able to boot (this is raid1 with 2 drives, and both drives need to be able to boot up the server by themselves in case the other drive fails later)? I remember I had to do the following before for the new drive:
>>
>> grub> root (hd0,0)
>>
>> Is that still the case here if marking it as 'spare'?
> If you want the new drive to boot and the boot sector is not covered by any
> md array, then you have to update the boot sector yourself.
>
> You can presumably get udev to run some command which will write a boot
> sector out.  However I'm not an expert on boot sector management so cannot
> really advise you.
Hi Neil,

I like the way you phrased that :)

I just wanted to clarify one point, it there a specific MD metadata 
version (I'm assuming either 1.0 or 1.2) which could be applied to an 
entire device MD array which would allow the automatic sync of the boot 
sectors/etc

ie, something like:
mdadm --create /dev/md3 --level=raid1 --metadata=1.2 /dev/sda /dev/sdb

then writing the boot sector information to /dev/md3
mdadm --manage /dev/md3 --fail /dev/sdb
mdadm --manage /dev/md3 --remove /dev/sdb
mdadm --manage /dev/md3 --add /dev/sdc

Then, shutdown, remove sda and sdb

Would you expect the system to boot successfully from sdc (assuming the 
BIOS will boot from it, and that the OS will "find" the correct boot and 
root device....

In the past I've always used partitions for MD, but this might be a good 
reason to use whole devices if it would solve the issue of the boot 
sector information.

Regards,
Adam
-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
