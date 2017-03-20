From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Read data from disk that was part of RAID1 array
Date: Mon, 20 Mar 2017 19:33:46 +0000
Message-ID: <58D02E9A.7080300@youngman.org.uk>
References: <008801d29ea3$3e858000$bb908000$@warren-selbert.com>
 <000c01d29f74$ae85c230$0b914690$@wnsdev.com>
 <58CE5AF8.5070907@youngman.org.uk>
 <006a01d2a1a0$ac148170$043d8450$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <006a01d2a1a0$ac148170$043d8450$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/03/17 17:37, Peter Sangas wrote:
>> From: Wols Lists [mailto:antlists@youngman.org.uk]
>> NEVER NEVER NEVER use --create !!!
>>
>>
>> Use something like --assemble --force, which will set up a working array
> if it can. 
> 
> OK, I tried this command but received an error:
> 
> mdadm --assemble --force  /dev/md10 /dev/sdc   
> 
> "Cannot assemble mbr metadata in /dev/sdc, no superblock"
> 
> What command do you suggest...?
> 
That makes it sound like something had trashed the superblock, or maybe
it was sdc1, or something. Anyways, it worked for you, so hopefully the
question is academic.
> 
> 
>> If that had been an old array, with a different offset or superblock or
> the like...
> 
> by "old" do you mean an array created using a different superblock format
> other than 1.2?
> 
Yes. The superblock format is v1. Whether it's v1.0, v1.1 or v1.2
depends on where the superblock is found. So if, for example, the array
had been created with a v1.0 superblock, the data would probably have
started at offset 2048, with the superblock at the end of the disk. v1.2
puts the superblock near the start, maybe offset 4096? So you would have
smashed some of your data, and also told the array to look in the wrong
place for the start of the data.

That's why --create is so dangerous - pick the wrong version and you can
damage the data, but even if you pick the right version, all the default
offsets and things have changed over the years (that's assuming they
haven't also been modified by general array management), so you can
easily lose where the data area starts.

Cheers,
Wol

