From: Kevin McAreavey <kevin.mcareavey@gmail.com>
Subject: Re: Damage when growing RAID 5 array
Date: Tue, 26 Feb 2013 14:18:19 +0000
Message-ID: <A13EF8F0-EE86-42A6-976F-B05632C00682@gmail.com>
References: <C4E6825B-3AF2-40E7-BD1B-65F988171FF2@gmail.com> <512C2AF3.90501@turmel.org> <83A60D93-15DE-4F45-97E8-A5A0A5E9C09C@gmail.com> <512CB72F.3080807@turmel.org> <9BA0752B-60DD-4BC6-B5C3-B1FBC9C50268@gmail.com> <512CBC6C.70005@turmel.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512CBC6C.70005@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26 Feb 2013, at 13:45, Phil Turmel wrote:

> Hi Kevin,
> 
> [top-posting repaired--please don't do that.]
> 
> On 02/26/2013 08:41 AM, Kevin McAreavey wrote:
>> On 26 Feb 2013, at 13:22, Phil Turmel wrote:
>> 
>>> On 02/26/2013 04:47 AM, Kevin McAreavey wrote:
>>>> Hi Phil,
>>>> 
>>>> Unfortunately I didn't specify a backup-file when attempting to grow the array so I'm not able to run this.
>>> 
>>> Hmmm.  That sounds like a bug.  It should have refused, I believe.  What
>>> kernel and mdadm versions are involved here?
>> 
>> $ uname -srv
>> Linux 3.2.0-37-generic-pae #58-Ubuntu SMP Thu Jan 24 15:51:02 UTC 2013
>> 
>> $ mdadm --version
>> mdadm - v3.2.5 - 18th May 2012
>> 
> 
> Try the assemble with "--backup-file=... --invalid-backup"
> The file must be outside the array, of course.
> 
> Phil

Hi Phil,

I ran that, it completed but didn't given me any message.

To be honest, I think I'm just going to cut my losses and start over.  I don't really know what I'm doing at this point and I've probably just been making it worse.

Thanks for your help!
Kevin