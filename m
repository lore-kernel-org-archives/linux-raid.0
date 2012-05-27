From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: very slow file deletion on an SSD
Date: Sat, 26 May 2012 19:07:27 -0500
Message-ID: <CAKuK5J2nAGGeFpJgRnb2trTriVDsbEQK_g-x86=nMdtsHs06yg@mail.gmail.com>
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard> <4FC16D65.8000008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC16D65.8000008@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, May 26, 2012 at 6:55 PM, Joe Landman <joe.landman@gmail.com> wrote:
> On 05/26/2012 07:18 PM, Dave Chinner wrote:
>
>> Sounds like you might be hitting the synchronous xattr removal
>> problem that was recently fixed (as has been mentioned already), but
>> even so 2 IOs don't take 1-2s to do, unless the MD RAID5 barrier
>> implementation is really that bad. If you mount -o nobarrier, what
>> happens?


Consider trying btrfs to eliminate the filesystem from the equation.
It should auto-detect that it's on an SSD.


-- 
Jon
