From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: How to prefer some devices over others in raid
Date: Tue, 31 Dec 2013 09:17:31 -0600
Message-ID: <52C2E00B.90406@hardwarefreak.com>
References: <CAL1oBhr+V0NQ1zG4LVP8qFT3_wsMHnqhUkZafVibtk0oCDGg5Q@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAL1oBhr+V0NQ1zG4LVP8qFT3_wsMHnqhUkZafVibtk0oCDGg5Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomas M <tomas@slax.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 12/31/2013 8:42 AM, Tomas M wrote:
> I'm using software raid 5 (stripe with one parity drive).
> 
> Is there a way to force the raid array to MOSTLY ignore one of the drives?
> 
> Let me explain. If a drive is failing (is very slow, has errors, etc),
> then I still prefer to keep it in the array and simply COPY all data
> from the array somewhere else, instead of risking that the array gets
> degraded if I remove the failing drive and another one dies at the
> same time.
> 
> Example:
> - 4 drives in raid5
> - one drive is slow, lets call the drive DISK1
> - copying all data from the array is very slow because it still uses
> DISK1 to read data from it, even if it could IGNORE it and COMPUTE the
> data from the other three drives
> 
> The filesystem on the array needs to be still mounted rw, though,
> since there may be some changes.
> 
> Is there any mdadm parameter or option which would make the array
> IGNORE any given disk on reads (since those can be computed from other
> drives), while still NOT IGNORING the disk in writes?
> 
> Because if I set it to ignore that failing slow drive, I will copy out
> the data 100 times faster while still keeping the array in sync.
> Because for me if ANOTHER drive dies, it will still be better to have
> the data 100 times slower than nothing. I hope you understand me :)

The option you request is not available TTBOMK.  So...

Fail the drive.  Copy all the data off the array.  Zero the drive and
add it back.  Resync.

But while you're at it, why not simply replace the flaky drive before
the resync?  Why would you intentionally keep a known-to-be-failing
drive in the array?

-- 
Stan

