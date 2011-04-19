From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: debian software raid1
Date: Wed, 20 Apr 2011 07:33:57 +1000
Message-ID: <4DADFFC5.3090009@crc.id.au>
References: <1303215166.2809.8.camel@valio> <BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com> <4DADB24F.2030300@cdf.toronto.edu> <alpine.DEB.2.00.1104192148270.4097@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1104192148270.4097@unicorn.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/04/2011 7:10 AM, Gordon Henderson wrote:
> I'm actually of the opinion that to NOT put swap on RAID in an otherwise
> RAIDed system is just plain silly. Do it. You know it makes sense!

I think the preferred method at the moment (and at least for 2010/2011) 
is to have a smallish RAID1 partition for /boot then create a second 
RAID array for everything else and use LVM on top of that.

That allows you to have the host on the same RAID1 and use the 
flexibility to use LVM for all your other requirements.

I personally run a Xen virtualisation server - it has the following:
/dev/md0 - /boot - 512Mb - RAID1
/dev/md1 - VG 'RAID1' - rest of disk - RAID1
/dev/md2 - VG 'RAID5' - 3 x 1Tb whole disks - RAID5

Then the majority of the 7 VMs on that machine live on the RAID5 VG 
(with one special case that is on the RAID1 VG) and it runs very happily.

The swap and root of Dom0 is on the RAID1 VG. This seems to be the best 
way I've found to have the most flexibility and not have to change 
things as time progresses.

--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299

There are no great men, only great challenges that ordinary men are 
forced by circumstances to meet. -- Admiral William Halsey
