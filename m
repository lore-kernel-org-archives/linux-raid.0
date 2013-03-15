From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Putting grub back on new mirror disk
Date: Thu, 14 Mar 2013 21:41:18 -0700
Message-ID: <5142A66E.9010304@vorgon.com>
References: <5141361F.7010505@vorgon.com> <CAD4F9C5-6A55-421A-BFAD-B23D72662054@colorremedies.com> <51423AAA.1070404@vorgon.com> <E1690A73-C20E-4EB9-97E9-ACDC22AE9904@colorremedies.com> <51423CB4.6010803@vorgon.com> <947D0B46-E42D-41A6-A408-99CB4AAA374C@colorremedies.com> <514241A2.6020301@vorgon.com> <608C7548-918F-4F11-A874-3399D8691538@colorremedies.com> <51426FDE.4090406@vorgon.com> <A7E78320-768A-43AE-AE1D-1BF9E52D5713@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A7E78320-768A-43AE-AE1D-1BF9E52D5713@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ok, was thinking it was checking that grub got installed. So the map may 
have had the old drive listed instead of the new drive. But the map was 
force updated to match.

On 3/14/2013 5:57 PM, Chris Murphy wrote:
> On Mar 14, 2013, at 6:48 PM, Timothy D. Lenz <tlenz@vorgon.com> wrote:
>
>> hd0 would have changed because it's a new drive. But all the numbers match the device list at /dev/disk/by-id
>
> I don't understand what you're saying or asking. The --recheck flag causes grub-install to look at /dev/disk/by-id to create a new device.map. So the device.map and /dev/disk/by-id should be the same, at least with this variant of GRUB. Some use /dev/sdX designations, some use UUID.
>
>
> Chris Murphy
>
