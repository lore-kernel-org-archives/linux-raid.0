From: Gordon Mohr <gojomo@bitzi.com>
Subject: Re: Shrinking on-disk size of RAID1 array?
Date: Fri, 30 Sep 2005 11:37:21 -0700
Message-ID: <433D85E1.5030708@bitzi.com>
References: <433CD4FA.6010603@bitzi.com> <63d08afd0509300232u36141930h@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <63d08afd0509300232u36141930h@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthew Coulson wrote:
>>I'm hoping to shrink the per-component size of an active RAID1
>>array, so that I can transition the array to a smaller, faster
>>set of drives.
> 
> 
> I may be missing something here, but why not connect up the new
> drives, setup the arrays, simply cp -R * everything over to the new
> filesystems and update fstab and mdadm.conf? I can understand wanting
> to let the system handle it all for you, but this way you'll get a
> free defrag to boot :)

Largest reason is that I want to minimize system downtime. My
working assumption is that the 'parted' resize and 'mdadm'
grow (shrink) would take minutes (or tens of minutes), then
the background sync to the new smaller drive could happen
at a leisurely pace, while services which actively write to
the array remain up.

I would expect a plain 'cp -R' to take hours, during
which (to be safe) all services using the array should be
stopped. (Perhaps I could do an initial 'cp -R' while services
are running, then a quicker rsync for consistency when services
are down?)

If my assumption about the relative time required of 'parted'
resize and 'mdadm' grow is wrong, the simple copy approach
would be more attractive.

- Gordon
