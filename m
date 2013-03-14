From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Putting grub back on new mirror disk
Date: Thu, 14 Mar 2013 14:01:30 -0700
Message-ID: <51423AAA.1070404@vorgon.com>
References: <5141361F.7010505@vorgon.com> <CAD4F9C5-6A55-421A-BFAD-B23D72662054@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAD4F9C5-6A55-421A-BFAD-B23D72662054@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Had a couple minutes, so here is the paste for just sda.

http://pastebin.com/5eMJELyx


x64VDR:/home/vorg# grub-install --version
grub-install (GRUB) 1.98+20100804-14


On 3/13/2013 8:34 PM, Chris Murphy wrote:
>
> On Mar 13, 2013, at 8:29 PM, Timothy D. Lenz <tlenz@vorgon.com> wrote:
>>
>> x64VDR:/home/vorg# grub-install /dev/sda && grub-install /dev/sdb
>
> What happens when you issue the commands separately?
>
>> /usr/sbin/grub-probe: error: no such disk.
>> Auto-detection of a filesystem of /dev/md0 failed.
>> Please report this together with the output of "/usr/sbin/grub-probe --device-map=/boot/grub/device.map --target=fs -v /boot/grub" to <bug-grub@gnu.org>
>
> I'm going to guess an old version of prerelease GRUB2 since device.map isn't used anymore. Dollars to donuts help-grub@ will ask you to upgrade to current upstream GRUB2.
>
> grub-install --version
>
> If installing to sda or sdb fail separately, use --debug flag and put that up on pastebin. Many, many changes are in the final release of 2.00, which is now about 9 months old.
>
>
> Chris Murphy
>
>
>
