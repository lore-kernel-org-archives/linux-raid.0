From: Sam Bingner <sam@bingner.com>
Subject: Re: Is (non-failed) disk replace possible without loosing
 redundancy ?
Date: Fri, 12 Apr 2013 00:52:49 +0000
Message-ID: <052128B0-8542-4F9E-A762-004435A23484@bingner.com>
References: <F5FBA8C0111F5C458B9E1BC24A3F4BDD01F43AAFA5@exchange2.ad.tlogica.com>
 <5166D3C5.5000407@websitemanagers.com.au>
 <runj3axnnb.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <runj3axnnb.ln2@goaway.wombat.san-francisco.ca.us>
Content-Language: en-US
Content-ID: <1A22B5EE5ABA284AA44FD9A7A4414D2A@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Apr 11, 2013, at 11:52 AM, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:

> On 2013-04-11, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:
>> 
>> I'm pretty sure this will work:
>> 1) mdadm --manage /dev/md0 --add /dev/sdc1 # Add spare device
>> 2) mdadm  --grow /dev/md0 --level=1 --raid-devices=3 # Grow the array to
>> three drive raid1
>> 3) mdadm --manage /dev/md0 --fail /dev/sdb1 # After the resync is
>> finished, fail the old disk2
>> 4) mdadm --manage /dev/md0 --remove /dev/sdb1 # Now remove the old disk2
>> 5) # Now physically remove disk2.
>> Repeat steps 1, 3, 4, 5 to replace disk1 with disk4.
>> 
>> 6) mdadm --grow /dev/md0 --level=1 --raid-devices=2 # Reduce the array
>> back to a two drive raid1
> 
> This seems like a reasonable way to replace a RAID1 device without
> losing redundancy.  Is there any way to accomplish the same sort of
> thing in a RAID5 or 6?  I am imagining something like, if I wanted to
> replace device 0, I'd create a RAID1 with that device and the new
> device, wait for that build to complete, then break the mirror and
> remove the old device 0, so that the new drive becomes the new device 0.
> I suppose one could create a RAID5 out of RAID1 components where each
> RAID1 is initially degraded, but that seems inelegant.  (I think this
> option may have been suggested on this list at one point.)
> 
> --keith
> 
> -- 
> kkeller@wombat.san-francisco.ca.us
> 

For a raid5 it's easy -- convert to a raid6 (and let it complete with an extra disk) for the conversion...  then fail, remove, and add disks one at a time while retaining a raid5 level of redundancy.  For a raid6 I don't think you have any such options.

For a raid0 - convert to a raid4, add a parity disk and let it sync, then replace the non-parity disk and resync, last convert back to raid0

Of course all these options require you to have room for an extra disk ;)

Sam