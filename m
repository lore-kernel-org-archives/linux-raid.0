From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: imsm raid is always readonly on boot
Date: Tue, 07 Feb 2012 21:24:16 +0100
Message-ID: <4F318870.60908@redhat.com>
References: <4F3111D9.2060303@profihost.ag> <4F314CBC.8010102@redhat.com> <4F316273.7030109@profihost.ag> <4F31634D.4010403@redhat.com> <AA1E3735-7CAE-41FD-8FF1-F7A5FC968088@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AA1E3735-7CAE-41FD-8FF1-F7A5FC968088@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/07/12 19:24, Stefan Priebe wrote:
>>> >> When booted from disk - output while in initramfs:
>>> >> ~# cat /proc/mdstat
>>> >> Personalities : [raid1]
>>> >> md126 : active (read-only) raid1 sda[1] sdb[0]
>>> >>      156288000 blocks super external:/md127/0 [2/2] [UU]
>>> >> 
>>> >> md127 : inactive sdb[1](S) sda[0](S)
>>> >>      5544 blocks super external:imsm
>> > 
>> > Does it stay read-only if you try to write to it?
> Yes as it is read-only and not auto-read-only.

Ok, I don't have a lot of ideas here - hopefully the Intel guys or Neil
will have some input.

Cheers,
Jes


