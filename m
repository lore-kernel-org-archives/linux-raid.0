From: Stan Hoeppner <stan@hardwarefreak.org>
Subject: Re: mdadm - raid6 best practices ?
Date: Fri, 22 Sep 2017 19:40:20 -0500
Message-ID: <89da68f8-2d31-4168-00f6-050a194cd2fa@hardwarefreak.org>
References: <CAMNNMLHLA8mEEKpX8UAXgZPYXyL+mhSBC74K_azC25z=+VAc7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMNNMLHLA8mEEKpX8UAXgZPYXyL+mhSBC74K_azC25z=+VAc7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nikhil Kshirsagar <nkshirsa@redhat.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/21/2017 10:55 PM, Nikhil Kshirsagar wrote:
> Hello linux-raid,
>
> A customer has some questions about raid6 best practices. They are
> using a 84-disk MD1280 Expansion Shelf (seagate disks). They want to
> use mdadm to setup a s/w raid, using raid6.
>
> The questions are
>
> a) recommended number of disks included in RAID array set?
> b) Is it possible to include all 84 disks in one array and leave 2 of
> them as host spare?
> c) Is there a raid6 best practices document to refer to ?
>
> Can anyone point me to me any internal docs or articles to construct a
> reply to the customer?
>
> Thanks,
> Nikhil.

The single most important question:

What is the workload?

Start the discussion there, or everything else is meaningless.

--
Stan
