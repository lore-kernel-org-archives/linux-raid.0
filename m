From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: mdadm raid5 with lvm: advantages?
Date: Wed, 12 Jan 2011 01:10:03 +1100
Message-ID: <4D2C64BB.6070803@crc.id.au>
References: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Grundy <richguk@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/01/2011 1:06 AM, Richard Grundy wrote:
> I'm building a new RAID5 array (of 5 1.5 TB drives) with mdadm and
> would like to know the benefits of creating an LVM on top of this are
> instead of just creating the filesystem on the md directly. I've never
> had a problem growing the array and then resizing the filesystem
> before and wondered if in this situation the only gain would be lvm
> snapshot stuff? I'm planning to use ext4 for this array, if that makes
> any difference.

I used lvm over RAID5 on my latest server. It runs the Xen Hypervisor to 
do virtualisation. It was the first project that I have *ever* used lvm 
on. I have to say, I'm quite impressed. I have a volume group that takes 
up the entire RAID5, then split that into logical volumes for each VM.

I guess the bottom line here is what you are using it for. If its one 
massive file dumping ground, then lvm probably won't get you any extra 
features. If you plan to have more things later on than a single 
filesystem, then it might be an advantage to put lvm on there now.

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299
