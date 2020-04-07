From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid-6 cannot reshape
Date: Tue, 7 Apr 2020 08:31:37 -0400
Message-ID: <44069d88-f838-2b8b-1002-a1fff5502d2d@turmel.org>
References: <24a0ef04-46a9-13ee-b8cb-d1a0a5b939fb@shenkin.org>
 <6b9b6d37-6325-6515-f693-0ff3b641a67a@shenkin.org>
 <3135fb29-cfaa-d8ac-264d-fd3110217370@shenkin.org>
 <CAAMCDecyr4R_z3-E8HYwYM4CyQtAY_nBmXdvvMkTgZCcCp7MjQ@mail.gmail.com>
 <5E8B5865.9060107@youngman.org.uk>
 <08d66411-5045-56e1-cbad-7edefa94a363@turmel.org>
 <945332b3-6a47-c2b3-7d1e-70a44f6fd370@shenkin.org>
 <b9bb796e-08cd-e10a-d345-992e5f3abea7@turmel.org>
 <618f5171-785f-09b0-8748-d2549d22c0ab@shenkin.org>
 <38852671-9c5a-3807-0284-41f902e5f81b@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <38852671-9c5a-3807-0284-41f902e5f81b@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Wols Lists <antlists@youngman.org.uk>, Roger Heflin <rogerheflin@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/7/20 8:28 AM, Phil Turmel wrote:
>>
>> Thanks Phil,
>>
>> The --invalid-backup parameter was necessary to get this up and running.
>>   It's now up with the 7th disk as a spare.  Shall I run fsck now, or can
>> I just try to grow again?
>>
>> proposed grow operation:
>>> mdadm --grow -raid-devices=7 --backup-file=/dev/usb/grow_md127.bak
>> /dev/md127
>>> mdadm --stop /dev/md127
>>> umount /dev/md127 # not sure if this is necessary
>>> resize2fs /dev/md127
> 
> An fsck could help, if any blocks did get moved.
> 
> I would not attempt a grow again until you find out why the previous 
> attempt didn't make progress.  Check if mdmon is running, and/or compile 
> a fresh copy of mdadm from source.  If you don't figure it out, you'll 
> just end up in the same spot again.


Oh, one more point:  Don't use a backup file.  Let mdadm shift the data 
offsets to get the temporary space needed.  (It'll run faster, too.)

(I don't see any mdadm --examine reports in the list thread.  Did you do 
them and keep the complete output?)

Phil
