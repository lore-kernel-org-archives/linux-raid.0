From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: raid 5 crashed
Date: Wed, 1 Jun 2016 12:07:31 +0800
Message-ID: <20b1858b-0cd7-a7de-82af-9167dbcfb09e@fnarfbargle.com>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk>
 <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
 <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
 <574C8EB9.3070706@youngman.org.uk>
 <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
 <574D958F.8060209@turmel.org> <574DDCBD.40801@youngman.org.uk>
 <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com>
 <CACsGCyQuPEXtgeW6QH-s_-eW9-SZ3J5s2s7CUzZRNemexTt3aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyQuPEXtgeW6QH-s_-eW9-SZ3J5s2s7CUzZRNemexTt3aw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 01/06/16 11:46, Edward Kuns wrote:
> On Tue, May 31, 2016 at 8:48 PM, Brad Campbell
> <lists2009@fnarfbargle.com> wrote:
>> Much better to try and get the array running in a read-only state with all
>> disks in place and clone the data from the array rather than the disks after
>> they've been ddrescued. In the case of a running array, a read error on one
>> of the array members will see the RAID attempt to get the data from
>> elsewhere (a reconstruction), whereas a read from a disc cloned with
>> ddrescue will happily just report what was a faulty sector as a big pile of
>> zeros, and *poof* your data is gone.
>
> My understanding is that mdraid will kick out a drive with an unrecoverable
> hardware error on a single sector.  (Is this incorrect?)  How do you add
> the drive back in and get the raid in a read-only mode that won't kick out
> drives for failures, thus allowing you to fully recover data on a (say)
> raid5 with bad sectors on every drive at different sectors offsets?

Yes, that is incorrect. If your timeouts are configured correctly the 
drive will report an uncorrectable error up the stack. MD will try to 
get the data from elsewhere and it will try to re-write the bad sector 
with the reconstructed data.

If your timeouts are *wrong* however, the drive will go away and try 
desperately to read the sector. This most often will take well in excess 
of the default 30 second ata stack timeout. So the ata stack will poke 
the drive after 30 seconds, but the drive is still tied up trying to 
recover the data. It sees this as the drive going away, and reports to 
MD that the drive is gone. *Bang* it's out of the array.

There are other issues associated with md trying to re-write the sector 
and failing (and some complexities around whether or not you have a bad 
block list) that may kick the drive if the write fails, but invariably 
it's a read timeout issue that causes this problem.

> I'm asking hypothetically.  I have my arrays scrubbed weekly to prevent
> this kind of surprise, and I keep multiple backups of my most important and
> irreplaceable data.

Certainly best practice. I was more lax until I encountered a 
misbehaving SIL controller that silently corrupted a significant 
proportion of a 16TB array.

> In the past, I had a mirror that kept kicking out one drive.  I never lost
> any data.  Between a decent backup policy and luck, I never experienced two
> drive failures at the same time.  It's likely that the drive was timing out
> on an unrecoverable read error, but the OS gave up first.  This was before
> I knew to fix that default (mis)tuning, as was discussed here recently.
> Last fall, that drive totally failed, and since, I've been paying much more
> attention to care-and-maintenance!

I do daily short SMART tests, weekly long SMART tests and monthly 
"check" scrubs of the RAID(s). I'm not saying it's best practice, but 
I've had several drives turn up SMART failures and managed to address 
those before it became an issue on any of the arrays.

I've used the '--force' parameter to mdadm to assemble an array after a 
sata controller failure and had good results, but I wasn't dealing with 
bad drives and the need to make things read-only, so I defer to those 
with more experience in that regard.

I have however done a *lot* of data recovery on single drives over the 
years and can absolutely vouch that dd will leave you in tears.


Regards,
Brad

