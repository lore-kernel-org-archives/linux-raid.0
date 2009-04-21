From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Poor write performance with write-intent bitmap?
Date: Tue, 21 Apr 2009 01:44:39 +0100
Message-ID: <49ED16F7.3040906@anonymous.org.uk>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com> <49ED096E.1000002@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49ED096E.1000002@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/04/2009 00:46, I wrote:
[...]
> # time dd if=/dev/zero of=big_file bs=4096 count=2560000
> 2560000+0 records in
> 2560000+0 records out
> 10485760000 bytes (10 GB) copied, 264.448 seconds, 39.7 MB/s
[...]
> I'm not quite sure whether I should be disappointed at my writes being 
> so slow. Certainly there's a lot of rattling during writing, which 
> probably indicates lots of seeks to write ext3's journal.

No, that's not it. Using a scratch logical volume over the md RAID-5 
isn't much better:

# time dd if=/dev/zero of=/dev/mapper/vg0-scratch bs=4096 count=2560000
2560000+0 records in
2560000+0 records out
10485760000 bytes (10 GB) copied, 230.036 seconds, 45.6 MB/s

real    3m50.077s
user    0m1.608s
sys     0m11.097s

It still rattles a lot, suggesting a lot of seeking. Now if I turn off 
the bitmap and try again:
# mdadm --grow /dev/md1 --bitmap=none
# time dd if=/dev/zero of=/dev/mapper/vg0-scratch bs=4096 count=2560000
2560000+0 records in
2560000+0 records out
10485760000 bytes (10 GB) copied, 110.17 seconds, 95.2 MB/s

real    1m50.346s
user    0m1.900s
sys     0m13.537s

That's more like it, and no more rattling. Can I tune settings for the 
internal bitmap, or is this something which will have improved anyway 
since my kernel (2.6.18-128.1.6.el5.centos.plusxen so essentially a 
prominent North American Enterprise Linux vendor's EL5 codebase for 
md/raid5)? I mean, I do want the bitmap, but I hadn't realised it was 
quite so expensive (not that it matters much in this particular 
application).

Cheers,

John.

