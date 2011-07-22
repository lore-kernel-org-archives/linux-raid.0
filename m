From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: standard performance (write speed 65Mb/s)
Date: Thu, 21 Jul 2011 19:24:12 -0500
Message-ID: <4E28C32C.1020701@hardwarefreak.com>
References: <201107181403.49563.raid1@fuckaround.org> <c5a1a83b370a0ddb063cfc828f124e6d.squirrel@fuckaround.org> <CAHX8RiR0MV1iL_OfrVAKGjr0gj7zxtuxFSzMijSgNfKcs0Zz0Q@mail.gmail.com> <201107211957.16493.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201107211957.16493.raid1@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <raid1@fuckaround.org>
Cc: Erwan Leroux <erwan.lerou@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/21/2011 12:57 PM, Pol Hallen wrote:

> dd if=/dev/zero of=/dev/md0 bs=1024M count=10
> 10+0 records in
> 10+0 records out
> 10737418240 bytes (11 GB) copied, 166.042 s, 64.7 MB/s

Do you not recall that I explained in detail, not two days ago, why you
should not use a 1GB block size when testing with dd in this manner?
And don't do this with the raw device.  The resulting numbers, no matter
how large or small, are irrelevant.

*Put a filesystem on md0* and do:

~$ dd if=/dev/zero of=/some/dir/test.dd bs=4096 count=2621440

And why on earth would you bother running this test while the array is
still building?  Again, the resulting figure is worthless to everyone.

-- 
Stan
