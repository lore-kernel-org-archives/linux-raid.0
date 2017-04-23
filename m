From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 18:29:18 +0200
Message-ID: <9092a1dd-6738-c417-3095-91cb7d459367@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
 <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
 <20170423154240.GA3494@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170423154240.GA3494@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/23/2017 05:42 PM, Andreas Klauer wrote:
> On Sun, Apr 23, 2017 at 05:11:08PM +0200, Patrik Dahlström wrote:
>> * I try to find 0x53EF (ext4 magic) within the first 128M of
>> /dev/sd[abcde]. Not after? This will be an indication of my "New
>> Offset". I need to adjust the offset a bit since the ext4 magic is
>> located at 0x438 offset.
> 
> Yes, that should be about it.
>  
>> * I create a 5 and a 6 drive raid set and try to find an offset where
>> they both carry the same raw data. With some overlays, I should be able
>> to create both these raids at the same time, correct?
> 
> Yes, two sets of overlays.
> 
> So overlay A is your 5 disk raid5, overlay B is your 6 disk raid5, 
> and then you'll just have to take a stab at it with hexdump.
> 
> So kind of like,
> 
> hexdump --skip $((17*1024*1024*1024)) --length 4096 /dev/md42
> hexdump --skip $((17*1024*1024*1024)) --length 4096 /dev/md43
> 
> If that produces the same random-looking data then your reshape 
> might have progressed 17G-ish and you could try to use that as 
> a starting point for a linear device mapping that uses the 
> first 17G of the 6 disk raid and everything else from the 5disk.
> 
> The further the grow processed the larger a zone of overlap there 
> should be since more data ends up on the additional drive so 
> the original representation of the same data isn't yet written 
> into on the old drives.
> 
> Does that make sense?
> 
> 5 disks: a b c d e   : f g h i j   : k l m n o   : p q r s t : ...
> 6 disks: a b c d e f : g h i j k l : m n o p q r : s t       : ...
> 
> If it stopped at "t", both have "r s t"... and that "r s t" 
> would be what you have to find. You have to be wary of false 
> matches though (such as zeroes or other common patterns of data 
> you might find anywhere).
> 
> And there's one more thing, you mentioned a disk had a bad sata cable.
> If that disk got kicked and reshape went on for a while afterwards, 
> you should take that disk out of consideration. (Specify as "missing" 
> when creating the arrays.) It will have outdated/unreshaped data on 
> it that would be hard to incorporate into your recovery attempt...
The bad SATA cable has been there for a while and reported spurious I/O
errors on the old 5 disk raid. It really started to produce I/O errors
when I placed the new drive in that slot.

Is it OK to specify the new drive as missing? No special information
that should be located on that drive?

I wrote a small program to help me locate the correct offset:
https://gist.github.com/Risca/3eda5e7aba3dc6b72d61e79eaf7cc147

I am on the right track with that program?

> 
> Regards
> Andreas Klauer
> 
