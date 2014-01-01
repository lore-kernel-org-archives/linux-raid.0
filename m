From: Tomas M <tomas@slax.org>
Subject: Re: How to prefer some devices over others in raid
Date: Wed, 1 Jan 2014 07:50:24 +0100
Message-ID: <CAL1oBhrVUTK5ayU=sgmVgP0Xu5eh1nGcfRjQSYALXXJMVE03+w@mail.gmail.com>
References: <CAL1oBhr+V0NQ1zG4LVP8qFT3_wsMHnqhUkZafVibtk0oCDGg5Q@mail.gmail.com>
 <52C2E00B.90406@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C2E00B.90406@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My main concern is that I'm not always 100% sure if a certain drive is
the root cause of slow read performance, so failing a wrong one would
have terrible consequences. On the other hand, if it was possible to
say "read the data with pretending one drive has failed, but write to
the array as if all drives are ok", then I could actually find out if
copying speed reverts to normal.

Maybe I should write a kernel patch to try this out. Any suggestions
where to start?

Tomas M

On Tue, Dec 31, 2013 at 4:17 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>
>
> On 12/31/2013 8:42 AM, Tomas M wrote:
>> I'm using software raid 5 (stripe with one parity drive).
>>
>> Is there a way to force the raid array to MOSTLY ignore one of the drives?
>>
>> Let me explain. If a drive is failing (is very slow, has errors, etc),
>> then I still prefer to keep it in the array and simply COPY all data
>> from the array somewhere else, instead of risking that the array gets
>> degraded if I remove the failing drive and another one dies at the
>> same time.
>>
>> Example:
>> - 4 drives in raid5
>> - one drive is slow, lets call the drive DISK1
>> - copying all data from the array is very slow because it still uses
>> DISK1 to read data from it, even if it could IGNORE it and COMPUTE the
>> data from the other three drives
>>
>> The filesystem on the array needs to be still mounted rw, though,
>> since there may be some changes.
>>
>> Is there any mdadm parameter or option which would make the array
>> IGNORE any given disk on reads (since those can be computed from other
>> drives), while still NOT IGNORING the disk in writes?
>>
>> Because if I set it to ignore that failing slow drive, I will copy out
>> the data 100 times faster while still keeping the array in sync.
>> Because for me if ANOTHER drive dies, it will still be better to have
>> the data 100 times slower than nothing. I hope you understand me :)
>
> The option you request is not available TTBOMK.  So...
>
> Fail the drive.  Copy all the data off the array.  Zero the drive and
> add it back.  Resync.
>
> But while you're at it, why not simply replace the flaky drive before
> the resync?  Why would you intentionally keep a known-to-be-failing
> drive in the array?
>
> --
> Stan
>
