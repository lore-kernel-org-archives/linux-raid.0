From: Phil Turmel <philip@turmel.org>
Subject: Re: Damage when growing RAID 5 array
Date: Tue, 26 Feb 2013 08:45:16 -0500
Message-ID: <512CBC6C.70005@turmel.org>
References: <C4E6825B-3AF2-40E7-BD1B-65F988171FF2@gmail.com> <512C2AF3.90501@turmel.org> <83A60D93-15DE-4F45-97E8-A5A0A5E9C09C@gmail.com> <512CB72F.3080807@turmel.org> <9BA0752B-60DD-4BC6-B5C3-B1FBC9C50268@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9BA0752B-60DD-4BC6-B5C3-B1FBC9C50268@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kevin McAreavey <kevin.mcareavey@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Kevin,

[top-posting repaired--please don't do that.]

On 02/26/2013 08:41 AM, Kevin McAreavey wrote:
> On 26 Feb 2013, at 13:22, Phil Turmel wrote:
> 
>> On 02/26/2013 04:47 AM, Kevin McAreavey wrote:
>>> Hi Phil,
>>>
>>> Unfortunately I didn't specify a backup-file when attempting to grow the array so I'm not able to run this.
>>
>> Hmmm.  That sounds like a bug.  It should have refused, I believe.  What
>> kernel and mdadm versions are involved here?
> 
> $ uname -srv
> Linux 3.2.0-37-generic-pae #58-Ubuntu SMP Thu Jan 24 15:51:02 UTC 2013
>
> $ mdadm --version
> mdadm - v3.2.5 - 18th May 2012
>

Try the assemble with "--backup-file=... --invalid-backup"
The file must be outside the array, of course.

Phil
