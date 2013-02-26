From: Kevin McAreavey <kevin.mcareavey@gmail.com>
Subject: Re: Damage when growing RAID 5 array
Date: Tue, 26 Feb 2013 09:47:15 +0000
Message-ID: <83A60D93-15DE-4F45-97E8-A5A0A5E9C09C@gmail.com>
References: <C4E6825B-3AF2-40E7-BD1B-65F988171FF2@gmail.com> <512C2AF3.90501@turmel.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512C2AF3.90501@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

Unfortunately I didn't specify a backup-file when attempting to grow the array so I'm not able to run this.

Thanks,
Kevin

On 26 Feb 2013, at 03:24, Phil Turmel wrote:

> On 02/25/2013 04:17 PM, Kevin McAreavey wrote:
> 
>> $ sudo mdadm --assemble /dev/md1
>> mdadm: Failed to restore critical section for reshape, sorry.
>>      Possibly you needed to specify the --backup-file
> 
> Did you follow this advice?  I doesn't look like it from the rest of
> your report.  (Reread that without the word "Possibly".)
> 
> Phil

