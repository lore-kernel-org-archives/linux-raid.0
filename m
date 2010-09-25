From: Luca Berra <bluca@comedia.it>
Subject: Re: How do I repair a checksum error in the superblock?
Date: Sat, 25 Sep 2010 17:41:02 +0200
Message-ID: <20100925154102.GA9746@maude.comedia.it>
References: <4C9BE30C.9060301@thenewhams.com> <20100925173124.4d73d984@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100925173124.4d73d984@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

since this started on linux-lvm ml i'll add some missing bits
On Sat, Sep 25, 2010 at 05:31:24PM +1000, Neil Brown wrote:
....
>> At the moment I fixed it by modifying the /etc/mdadm/mdadm.conf file  as 
>> follows:
>> 
>> DEVICE /dev/sd[bcde]1
>> ARRAY /dev/md0 level=raid5 num-devices=4 
>> UUID=08558923:881d9efd:464c249d:988d2ec6
>> 
....
>I would do
>   mdadm --assemble --force --update=summaries /dev/md0 /dev/sd[abcd]1
>
>and see if that works.

Watch it, due to drive renumbering it should be:
mdadm --assemble --force --update=summaries /dev/md0 /dev/sd[bcde]1
>> 
>>     * The last problem is that I believe that one of the drives has
>>       additional metadata. This caused Ubuntu to see an additional
>>       partition /dev/md0lp1 in addition to /dev/md0. What is the best
>>       way of removing it?
>
>Did you mean "/dev/md0p1", or was there really an 'l' in there??
>
>That just means that the array (/dev/md0) has a partition table.  If you want
>to remove a partition table, then maybe use fdisk.
no, the problem is a little bit more complex
it seems he has duplicate metadata on each drive one for the whole drive
the other for the partition
ubuntu assembles the whole drive first, and mdadm finds the partition
table on the first disk and believe it is a partitioned md device.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
