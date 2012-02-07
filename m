From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: imsm raid is always readonly on boot
Date: Tue, 07 Feb 2012 18:45:49 +0100
Message-ID: <4F31634D.4010403@redhat.com>
References: <4F3111D9.2060303@profihost.ag> <4F314CBC.8010102@redhat.com> <4F316273.7030109@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F316273.7030109@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/07/12 18:42, Stefan Priebe wrote:
> Hi Jes,
> 
> Am 07.02.2012 17:09, schrieb Jes Sorensen:
>> /dev/md126 looks to be the container, not the actual raid device, from
>> what your mdadm.conf says.
> 
> booted from a rescue CD using 2.6.32 kernel.
> 
> ~# mdadm -D --scan
> ARRAY /dev/md/imsm0 metadata=imsm UUID=24cdb70d:101f4c4b:23dfa5cb:3f176b6a
> ARRAY /dev/md/RaidStefan_0 container=/dev/md/imsm0 member=0
> UUID=84aa9982:ed593d80:ee7c7f53:e2944038
> 
> ~# cat /proc/mdstat
> Personalities : [raid1]
> md126 : active (auto-read-only) raid1 sda[1] sdb[0]
>       156288000 blocks super external:/md127/0 [2/2] [UU]
> 
> md127 : inactive sdb[1](S) sda[0](S)
>       5544 blocks super external:imsm
> 
> unused devices: <none>
> 
> so md126 is the real raid.
> 
>> What does your /proc/mdstat say?
> 
> When booted from disk - output while in initramfs:
> ~# cat /proc/mdstat
> Personalities : [raid1]
> md126 : active (read-only) raid1 sda[1] sdb[0]
>       156288000 blocks super external:/md127/0 [2/2] [UU]
> 
> md127 : inactive sdb[1](S) sda[0](S)
>       5544 blocks super external:imsm

Does it stay read-only if you try to write to it?

Jes

