From: Mike Hardy <mhardy@h3c.com>
Subject: Re: raid5 disaster
Date: Tue, 23 May 2006 14:07:24 -0700
Message-ID: <4473798C.2060208@h3c.com>
References: <200605232245.27660.stickman@ole.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200605232245.27660.stickman@ole.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bruno Seoane <stickman@ole.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Bruno Seoane wrote:

> mdadm -C -l5 -n5 
> -c=128 /dev/md0 /dev/sdb1 /dev/sdd1 /dev/sde1 /dev/sdc1 /dev/sda1
> 
> I took the devices order from the mdadm output on a working device. Is this 
> the way it's supposed to be the command assembled?
> 
> Is there anything alse I should consider or any other valid solution to gain 
> access to my data?


If you create the array, it will immediately start resyncing unless you
list one of the devices in your command line as "missing". Just pick one
(ideally one of the ones that isn't getting picked up anyway) and put
'missing' in its place.

Using "missing" is the only way to have it be read-only in the data
regions. That'll let you make a mistake and still be able to recover
data after you find the right command line.

-Mike
