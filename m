From: Kevin McAreavey <kevin.mcareavey@gmail.com>
Subject: Re: Damage when growing RAID 5 array
Date: Tue, 26 Feb 2013 13:41:56 +0000
Message-ID: <9BA0752B-60DD-4BC6-B5C3-B1FBC9C50268@gmail.com>
References: <C4E6825B-3AF2-40E7-BD1B-65F988171FF2@gmail.com> <512C2AF3.90501@turmel.org> <83A60D93-15DE-4F45-97E8-A5A0A5E9C09C@gmail.com> <512CB72F.3080807@turmel.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512CB72F.3080807@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

$ uname -srv
Linux 3.2.0-37-generic-pae #58-Ubuntu SMP Thu Jan 24 15:51:02 UTC 2013

$ mdadm --version
mdadm - v3.2.5 - 18th May 2012

On 26 Feb 2013, at 13:22, Phil Turmel wrote:

> On 02/26/2013 04:47 AM, Kevin McAreavey wrote:
>> Hi Phil,
>> 
>> Unfortunately I didn't specify a backup-file when attempting to grow the array so I'm not able to run this.
> 
> Hmmm.  That sounds like a bug.  It should have refused, I believe.  What
> kernel and mdadm versions are involved here?

