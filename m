From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid Problem - Unknown File System Type
Date: Wed, 09 Nov 2011 15:05:27 -0500
Message-ID: <4EBADD07.5030109@turmel.org>
References: <4EBAA68B.6090906@rogers.com> <20111109163933.GA26630@cthulhu.home.robinhill.me.uk> <4EBAB47C.5070002@rogers.com> <4EBACC88.8070403@turmel.org> <4EBADB1E.1070700@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBADB1E.1070700@rogers.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Colls <william.colls@rogers.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/09/2011 02:57 PM, William Colls wrote:
> On 11/09/2011 01:55 PM, Phil Turmel wrote:
>> Hi William,
>>
>> On 11/09/2011 12:12 PM, William Colls wrote:
>> [...]
>>
>>> I thought, at the time, that I needed to do the create so that the /dev/md0 device would be created properly (new machine had no raid before).
>>
>> That's the "--auto" option, which has sane defaults.
>>
>> [...]
>>
>>> No output from the original setup.
>>
>>> From what you've described so far, a likely possibility is that the original raid 1 was using metadata version 1.1 or 1.2, which put the superblock near the beginning of the disks.  The default "--create" metadata in that old version of mdadm is 0.9, as you can see in your reports.
>>
>> If so, you've likely only lost a tiny bit of data at the end of the volumes where the 0.90 superblock has been written.  (I'm also going to assume that the two disks were in-sync in old box before you moved them, so the re-sync wouldn't do any harm.)
>>
>> A dump of the first 8K of your drives might be helpful here.
>>
>> dd if=/dev/sdb count=16 2>/dev/null |hexdump -C
>>
>> dd if=/dev/sdc count=16 2>/dev/null |hexdump -C
>>
>> Regards,
>>
>> Phil
>>
> 
> Did the dumps to text files. diff shows no difference between the files. Should I be looking for anything particular? There are sections which seem to have data, and several blocks that are all zeros, but I don't see any particular patterns, and only a very few obvious text strings.
> 
> Thanks for your interest and help.

I was expecting them to be nearly identical, unless they're corrupted.  I was particularly interested to see if an MD signature shows up at offsets 0 or 1000H, with device names at 20H or 1020H.

Or there might have been a partition table or boot loader showing, or fragments thereof.

I can't see them, of course.  (Hint.)

Phil
