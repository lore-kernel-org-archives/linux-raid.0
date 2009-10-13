From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 16:38:55 +1300
Message-ID: <4AD3F64F.6070908@sauce.co.nz>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mark delfman wrote:
> Hi... in recent tests we are seeing a 50% drop in performance from
> XFS>MD on a 2.6.30 kernel (compared to a 2.6.28 kernel)


Richard Scobie wrote:
 > Started testing a similar machine yesterday - 12GB RAM LSI SAS
 > controller and 16 x WD RE3 1TB SATA md RAID6.
 >
 > With stripe cache set to 16384, I see dd writes of around 290MB/s and
 > when bumped up to 32768 (the maximum), it increases to 407MB.

An omission to the above - the machine is running 
kernel-2.6.30.8-64.fc11.x86_64.

Regards,

Richard

