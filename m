From: Brendan Conoboy <blc@redhat.com>
Subject: Re: Configuring RAID5 w/ Spare?
Date: Thu, 11 Mar 2010 11:16:16 -0700
Message-ID: <4B993370.2040003@redhat.com>
References: <d80f793f1003111011m588e1bdem3a9d934ff0fdc35e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1003111011m588e1bdem3a9d934ff0fdc35e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/11/2010 11:11 AM, Carlos Mennens wrote:
> Now I make the same thing for /dev/sdb&  /dev/sdc. I DON'T PARTITION
> OR FORMAT /dev/sdd.

Why not partition?  It's possible to create a floating spare, but it 
doesn't really make sense for the configuration you've described.  Just 
add identical partitions on sdd and include the respective partitions on 
each of your array creation commands.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
